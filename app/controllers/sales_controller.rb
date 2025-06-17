class SalesController < ApplicationController
  def index
    @orderables = Orderable.all
    @cart = Cart.last
    check_cart = Cart.where(balance: 0)
    check_cart.destroy_all
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @start_date_expense = params[:start_date_expense]
    @end_date_expense = params[:end_date_expense]
    @expense_id = params[:expense_id]
    @expense_id_date = params[:expense_id_date]

    @cash_register_lists = CashRegisterList.all
  end

  def sales_data
    @carts = Cart.where(date: params[:date])
  end

  def report_month_sales
    start_date = params[:start_date]
    end_date = params[:end_date]

    sold_carts = Cart.where(created_at: start_date..end_date).where("balance > 0")
    orderables = Orderable.includes(:product).where(cart_id: sold_carts)
    produtos = {}
    totais_por_categoria = Hash.new(0)

    orderables.each do |o|
      produto = o.product
      nome = produto.name
      categoria =
        if nome.upcase.include?("VIGA")
          "VIGAS"
        elsif nome.upcase.include?("CAIBRO")
          "CAIBRO"
        elsif nome.upcase.include?("FRECHAL")
          "FRECHAL"
        elsif nome.upcase.include?("RIPA")
          "RIPA"
        else
          "OUTROS"
        end

      produtos[categoria] ||= {}
      produtos[categoria][nome] ||= { quantidade: 0, valor: 0 }
      produtos[categoria][nome][:quantidade] += o.quantity
      produtos[categoria][nome][:valor] += o.quantity * produto.sale_price
      totais_por_categoria[categoria] += o.quantity * produto.sale_price
    end

    pdf = Prawn::Document.new(page_size: 'A4', page_layout: :landscape) do |pdf|
      ENV['LC_TIME'] = 'pt_BR.UTF-8'
      mes_ano = Date.today.strftime('%B de %Y').capitalize
      pdf.text "Relatório Mensal - #{mes_ano}", size: 18, style: :bold, align: :center

      pdf.move_down 20

      data = [["Produto", "Quantidade", "Custo Médio (R$)", "Valor Médio (R$)", "Valor Total (R$)", "Lucro (%)"]]

      produtos.each do |categoria, itens|
        itens.each do |nome, dados|
          valor_total = dados[:valor]
          quantidade = dados[:quantidade]
          valor_medio = quantidade > 0 ? (valor_total / quantidade) : 0

          produto = Product.find_by(name: nome)
          custo_unitario = produto&.purchase_price || 0
          custo_total = custo_unitario * quantidade
          custo_medio = quantidade > 0 ? (custo_total / quantidade) : 0

          lucro = valor_total - custo_total
          percentual_lucro = custo_total > 0 ? (lucro / custo_total * 100) : 0

          valor_total_formatado = number_to_currency(valor_total, unit: 'R$', separator: ',', delimiter: '.')
          valor_medio_formatado = number_to_currency(valor_medio, unit: 'R$', separator: ',', delimiter: '.')
          custo_medio_formatado = number_to_currency(custo_medio, unit: 'R$', separator: ',', delimiter: '.')

          percentual_lucro_formatado = "#{percentual_lucro.round(1)}%"

          data << [
            nome,
            quantidade.to_s,
            custo_medio_formatado,
            valor_medio_formatado,
            valor_total_formatado,
            percentual_lucro_formatado
          ]
        end
      end

      pdf.table(data, header: true, cell_style: { size: 10, borders: [], padding: [4, 14]})

      pdf.move_down 20

      total_geral = totais_por_categoria.values.sum
      total_formatado = number_to_currency(total_geral, unit: 'R$', separator: ',', delimiter: '.')
      pdf.text "Total de Vendas: #{total_formatado}", style: :bold, align: :right
    end

    send_data(pdf.render,
      filename: "relatorio_mensal_#{Date.today.strftime('%Y_%m')}.pdf",
      type: 'application/pdf')
  end


  def report_year_sales
    start_date = Date.today.beginning_of_year
    end_date = Date.today.end_of_year

    sold_carts = Cart.where(created_at: start_date..end_date).where("balance > 0")
    orderables = Orderable.includes(:product).where(cart_id: sold_carts)
    produtos = {}
    totais_por_categoria = Hash.new(0)

    orderables.each do |o|
      produto = o.product
      nome = produto.name
      categoria =
        if nome.upcase.include?("VIGA")
          "VIGAS"
        elsif nome.upcase.include?("CAIBRO")
          "CAIBRO"
        elsif nome.upcase.include?("FRECHAL")
          "FRECHAL"
        elsif nome.upcase.include?("RIPA")
          "RIPA"
        else
          "OUTROS"
        end

      produtos[categoria] ||= {}
      produtos[categoria][nome] ||= { quantidade: 0, valor: 0 }
      produtos[categoria][nome][:quantidade] += o.quantity
      produtos[categoria][nome][:valor] += o.quantity * produto.sale_price
      totais_por_categoria[categoria] += o.quantity * produto.sale_price
    end

    pdf = Prawn::Document.new do |pdf|
      ENV['LC_TIME'] = 'pt_BR.UTF-8'
      mes_ano = Date.today.strftime('%B de %Y').capitalize
      pdf.text "Relatório Mensal - #{mes_ano}", size: 18, style: :bold, align: :center
      pdf.move_down 20

      produtos.each do |categoria, itens|
        pdf.text categoria, size: 14, style: :bold
        data = [["Produto", "Quantidade", "Valor Total (R$)"]]

        itens.each do |nome, dados|
          valor_formatado = number_to_currency(
            dados[:valor], unit: 'R$', separator: ',', delimiter: '.'
          )
          data << [nome, dados[:quantidade].to_s, valor_formatado]
        end

        pdf.table(data, header: true, row_colors: ["F0F0F0", "FFFFFF"], cell_style: { size: 10 })
        pdf.move_down 15
      end

      pdf.move_down 20
      pdf.text "Totais por Categoria:", size: 14, style: :bold
      totais_por_categoria.each do |categoria, total|
        total_formatado = number_to_currency(
          total, unit: 'R$', separator: ',', delimiter: '.'
        )
        pdf.text "#{categoria}: #{total_formatado}", size: 12
      end

      pdf.move_down 10
      total_geral = totais_por_categoria.values.sum
      total_formatado = number_to_currency(
        total_geral, unit: 'R$', separator: ',', delimiter: '.'
      )
      pdf.text "Total de Vendas: #{total_formatado}", size: 16, style: :bold, align: :right
    end

    send_data(pdf.render,
      filename: "relatorio_anual_#{Date.today.strftime('%Y_%m')}.pdf",
      type: 'application/pdf')
  end


  def download_pdf
    check_cart = Cart.where(balance: 0)
    check_cart.destroy_all
    total_total = 0
    carts = Cart.where(date: params[:date])
    pdf = Prawn::Document.new do |pdf|
      # Título do relatório
      pdf.text "Relatório de Vendas #{carts.first.date&.strftime('%d/%m/%Y')}", size: 20, style: :bold, align: :center
      pdf.move_down 20

      # Cabeçalho da tabela
      header = [['Cliente', 'Produto', 'Quantidade', 'Valor do Produto', 'Valor Total']]

      # Desenha o cabeçalho da tabela
      pdf.table(header, header: true, column_widths: [175, 130, 85, 75, 75], position: :center,
                        cell_style: { font_style: :bold, background_color: 'CCCCCC', border_width: 0.5 }) do
        columns(0..4).align = :center
        cells.borders = []
      end

      pdf.move_down 10

      carts.each_with_index do |cart, index|
        # Adiciona uma linha separadora antes de cada novo cliente, exceto o primeiro
        if index >= 0
          pdf.stroke_horizontal_rule
          pdf.move_down 10
        end

        # Dados da tabela para o cliente atual
        table_data = [[cart.orderables.first.client.name, '', '', '', '']]

        cart_items = cart.orderables.map do |cart_orderable|
          total_total += cart_orderable.total
          table_data << ['',
                         cart_orderable.product.name,
                         cart_orderable.quantity,
                         number_to_currency(cart_orderable.product.sale_price, unit: 'R$', separator: ',',
                                                                               delimiter: '.'),
                         number_to_currency(cart_orderable.total, unit: 'R$', separator: ',', delimiter: '.')]
        end

        # Desenha a tabela para o cliente atual
        pdf.table(table_data, column_widths: [175, 140, 75, 75, 75], position: :center,
                              cell_style: { height: 19, size: 10 }) do
          row(0).background_color = 'CCCCCC'
          columns(0..4).align = :center
          cells.borders = []
        end
        pdf.move_down 10
        # Linha com o total do carrinho do cliente
        pdf.text "VALOR TOTAL DO PEDIDO: #{number_to_currency(cart.total, unit: 'R$', separator: ',', delimiter: '.')}",
                 style: :bold, align: :right
        pdf.move_down 10
        pdf.stroke_horizontal_rule
      end

      pdf.move_down 10
      pdf.text "Total: #{number_to_currency(total_total, unit: 'R$', separator: ',', delimiter: '.')}", size: 16,
                                                                                                        style: :bold, align: :right
      pdf.move_down 10
      pdf.stroke_horizontal_rule
    end
    send_data(pdf.render,
              filename: "Relatório Vendas #{carts.first.date&.strftime('%d/%m/%Y')}.pdf",
              type: 'application/pdf')
  end

  def all_sales_download_pdf
    check_cart = Cart.where(balance: 0)
    check_cart.destroy_all
    total_total = 0
    carts = Cart.all
    pdf = Prawn::Document.new do |pdf|
      # Título do relatório
      pdf.text 'Relatório de Vendas Gerais', size: 20, style: :bold, align: :center
      pdf.move_down 20

      # Cabeçalho da tabela
      header = [['Cliente', 'Produto', 'Quantidade', 'Valor do Produto', 'Valor Total']]

      # Desenha o cabeçalho da tabela
      pdf.table(header, header: true, column_widths: [175, 130, 85, 75, 75], position: :center,
                        cell_style: { font_style: :bold, background_color: 'CCCCCC', border_width: 0.5 }) do
        columns(0..4).align = :center
        cells.borders = []
      end

      pdf.move_down 10

      carts.each_with_index do |cart, index|
        # Adiciona uma linha separadora antes de cada novo cliente, exceto o primeiro
        if index >= 0
          pdf.stroke_horizontal_rule
          pdf.move_down 10
        end

        # Dados da tabela para o cliente atual
        table_data = [[cart.orderables.first.client.name, '', '', '', '']]

        cart_items = cart.orderables.map do |cart_orderable|
          total_total += cart_orderable.total
          table_data << ['',
                         cart_orderable.product.name,
                         cart_orderable.quantity,
                         number_to_currency(cart_orderable.product.sale_price, unit: 'R$', separator: ',',
                                                                               delimiter: '.'),
                         number_to_currency(cart_orderable.total, unit: 'R$', separator: ',', delimiter: '.')]
        end

        # Desenha a tabela para o cliente atual
        pdf.table(table_data, column_widths: [175, 140, 75, 75, 75], position: :center,
                              cell_style: { height: 19, size: 10 }) do
          row(0).background_color = 'CCCCCC'
          columns(0..4).align = :center
          cells.borders = []
        end
        pdf.move_down 10
        # Linha com o total do carrinho do cliente
        pdf.text "VALOR TOTAL DO PEDIDO: #{number_to_currency(cart.total, unit: 'R$', separator: ',', delimiter: '.')}",
                 style: :bold, align: :right
        pdf.move_down 10
        pdf.stroke_horizontal_rule
      end

      pdf.move_down 10
      pdf.text "Total: #{number_to_currency(total_total, unit: 'R$', separator: ',', delimiter: '.')}", size: 16,
                                                                                                        style: :bold, align: :right
      pdf.move_down 10
      pdf.stroke_horizontal_rule
    end
    send_data(pdf.render,
              filename: 'Relatório Vendas Gerais.pdf',
              type: 'application/pdf')
  end

  def period_sales_download_pdf
    check_cart = Cart.where(balance: 0)
    check_cart.destroy_all
    total_total = 0
    start_date = params[:start_date].to_date
    end_date = params[:end_date].to_date.end_of_day
    carts = Cart.where(date: start_date..end_date)

    pdf = Prawn::Document.new do |pdf|
      # Título do relatório
      pdf.text "Relatório de Vendas de #{start_date&.strftime('%d/%m/%Y')} a #{end_date&.strftime('%d/%m/%Y')}",
               size: 20, style: :bold, align: :center
      pdf.move_down 20

      # Cabeçalho da tabela
      header = [['Cliente', 'Produto', 'Quantidade', 'Valor do Produto', 'Valor Total']]

      # Desenha o cabeçalho da tabela
      pdf.table(header, header: true, column_widths: [175, 130, 85, 75, 75], position: :center,
                        cell_style: { font_style: :bold, background_color: 'CCCCCC', border_width: 0.5 }) do
        columns(0..4).align = :center
        cells.borders = []
      end

      pdf.move_down 10

      carts.each_with_index do |cart, index|
        # Adiciona uma linha separadora antes de cada novo cliente, exceto o primeiro
        if index > 0
          pdf.stroke_horizontal_rule
          pdf.move_down 10
        end

        # Dados da tabela para o cliente atual
        table_data = [[cart.orderables.first.client.name, '', '', '', '']]

        cart.orderables.each do |cart_orderable|
          total_total += cart_orderable.total
          table_data << ['',
                         cart_orderable.product.name,
                         cart_orderable.quantity,
                         number_to_currency(cart_orderable.product.sale_price, unit: 'R$', separator: ',',
                                                                               delimiter: '.'),
                         number_to_currency(cart_orderable.total, unit: 'R$', separator: ',', delimiter: '.')]
        end

        # Desenha a tabela para o cliente atual
        pdf.table(table_data, column_widths: [175, 140, 75, 75, 75], position: :center,
                              cell_style: { height: 19, size: 10 }) do
          row(0).background_color = 'CCCCCC'
          columns(0..4).align = :center
          cells.borders = []
        end
        pdf.move_down 10
        # Linha com o total do carrinho do cliente
        pdf.text "VALOR TOTAL DO PEDIDO: #{number_to_currency(cart.total, unit: 'R$', separator: ',', delimiter: '.')}",
                 style: :bold, align: :right
        pdf.move_down 10
        pdf.stroke_horizontal_rule
      end

      pdf.move_down 10
      pdf.text "Total: #{number_to_currency(total_total, unit: 'R$', separator: ',', delimiter: '.')}", size: 16,
                                                                                                        style: :bold, align: :right
      pdf.move_down 10
      pdf.stroke_horizontal_rule
    end

    send_data(pdf.render,
              filename: "Relatório Vendas #{start_date&.strftime('%d/%m/%Y')} - #{end_date&.strftime('%d/%m/%Y')}.pdf",
              type: 'application/pdf')
  end

  def show_sale
    check_cart = Cart.where(balance: 0)
    check_cart.destroy_all
    @cart = Cart.find_by(id: params[:cart_id])
  end

  def expense_report
    expense_id = params[:expense_id].to_i
    expense = Expense.find_by(id: expense_id)
    total_total = 0
    @cash_register_lists = CashRegisterList.where(expense_id: expense_id) # Ajuste isso conforme a sua lógica de negócio

    pdf = Prawn::Document.new do |pdf|
      # Título do relatório
      pdf.text 'Relatório Plano de Contas', size: 20, style: :bold, align: :center
      pdf.move_down 20

      # Nome da despesa
      pdf.text "#{expense.name}", size: 18, style: :bold, align: :center
      pdf.move_down 20

      # Cabeçalho da tabela
      header = [['Data', 'Saldo']]

      # Dados da tabela
      content = @cash_register_lists.map do |cash_register_list|
        total_total += cash_register_list.balance
        [
          cash_register_list.date.strftime('%d/%m/%Y'), # Formatando a data
          number_to_currency(cash_register_list.balance, unit: 'R$', separator: ',', delimiter: '.')
        ]
      end

      # Combina o cabeçalho com o conteúdo
      table_data = header + content

      # Desenha a tabela
      pdf.table(table_data, header: true, column_widths: [175, 140, 100], position: :center, cell_style: { font_style: :bold} ) do
        row(0).background_color = 'CCCCCC' # Fundo cinza para o cabeçalho
        row(-1).background_color = 'FFFFFF' # Fundo branco para o corpo da tabela
        columns(0..2).align = :center
        cells.borders = []
      end

      pdf.move_down 10

      # Linha com o total do relatório
      total_data = [["", "Total", number_to_currency(total_total, unit: 'R$', separator: ',', delimiter: '.')]]
      pdf.table(total_data, column_widths: [175, 140, 100], position: :center, cell_style: { font_style: :bold, background_color: 'CCCCCC', border_width: 0.5 }) do
        columns(0..2).align = :center
        cells.borders = []
      end
      pdf.move_down 10
    end

    send_data pdf.render,
              filename: "relatorio_plano_de_contas_#{expense.name}.pdf",
              type: 'application/pdf',
              disposition: 'attachment' # Use "attachment" para forçar o download
  end

  def expense_report_data
    expense_id_date = params[:expense_id_date].to_i
    expense = Expense.find_by(id: expense_id_date)
    total_total = 0
    start_date_expense =  params[:start_date_expense].to_date
    end_date_expense = params[:end_date_expense].to_date
    @cash_register_lists = CashRegisterList.where(expense_id: expense_id_date, date:start_date_expense..end_date_expense) # Ajuste isso conforme a sua lógica de negócio

    pdf = Prawn::Document.new do |pdf|
      # Título do relatório
      pdf.text "Relatório de Plano de Contas de #{start_date_expense&.strftime('%d/%m/%Y')} a #{end_date_expense&.strftime('%d/%m/%Y')}",size: 20, style: :bold, align: :center
      pdf.move_down 20

      # Nome da despesa
      pdf.text "#{expense.name}", size: 18, style: :bold, align: :center
      pdf.move_down 20

      # Cabeçalho da tabela
      header = [['Data', 'Saldo']]

      # Dados da tabela
      content = @cash_register_lists.map do |cash_register_list|
        total_total += cash_register_list.balance
        [
          cash_register_list.date.strftime('%d/%m/%Y'), # Formatando a data
          number_to_currency(cash_register_list.balance, unit: 'R$', separator: ',', delimiter: '.')
        ]
      end

      # Combina o cabeçalho com o conteúdo
      table_data = header + content

      # Desenha a tabela
      pdf.table(table_data, header: true, column_widths: [175, 140, 100], position: :center, cell_style: { font_style: :bold} ) do
        row(0).background_color = 'CCCCCC' # Fundo cinza para o cabeçalho
        row(-1).background_color = 'FFFFFF' # Fundo branco para o corpo da tabela
        columns(0..2).align = :center
        cells.borders = []
      end

      pdf.move_down 10

      # Linha com o total do relatório
      total_data = [["", "Total", number_to_currency(total_total, unit: 'R$', separator: ',', delimiter: '.')]]
      pdf.table(total_data, column_widths: [175, 140, 100], position: :center, cell_style: { font_style: :bold, background_color: 'CCCCCC', border_width: 0.5 }) do
        columns(0..2).align = :center
        cells.borders = []
      end
      pdf.move_down 10
    end

    send_data pdf.render,
              filename: "relatorio_plano_de_contas_#{expense.name}.pdf",
              type: 'application/pdf',
              disposition: 'attachment' # Use "attachment" para forçar o download
  end


  private

  # Helper method to format numbers as currency
  def number_to_currency(number, options = {})
    unit      = options[:unit]      || 'R$'
    separator = options[:separator] || ','
    delimiter = options[:delimiter] || '.'
    format('%s %0.2f', unit, number).gsub('.', separator).gsub(/(\d)(?=(\d{3})+(?!\d))/, "\\1#{delimiter}")
  end
end
