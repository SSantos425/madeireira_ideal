class SalesController < ApplicationController
    def index
        @orderables = Orderable.all
        @cart = Cart.last
    end

    def sales_data
        @carts = Cart.where(date: params[:date])
    end

    def preview_pdf
      total_total = 0
      carts = Cart.where(date: params[:date])
      pdf = Prawn::Document.new do |pdf|
        # Título do relatório
        pdf.text "Relatório de Vendas #{carts.first.date&.strftime('%d/%m/%Y')}", size: 20, style: :bold, align: :center
        pdf.move_down 20

        # Cabeçalho da tabela
        header = [['Cliente', 'Produto', 'Quantidade', 'Valor do Produto', 'Valor Total']]

        # Desenha o cabeçalho da tabela
        pdf.table(header, header: true, column_widths: [175, 130, 85, 75, 75], position: :center, cell_style: { font_style: :bold, background_color: 'CCCCCC', border_width: 0.5 }) do
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
                              number_to_currency(cart_orderable.product.sale_price, unit: "R$", separator: ",", delimiter: "."),
                              number_to_currency(cart_orderable.total, unit: "R$", separator: ",", delimiter: ".")
                            ]
            end

            # Desenha a tabela para o cliente atual
            pdf.table(table_data, column_widths: [175, 140, 75, 75, 75], position: :center, cell_style: { border_width: 0.5 }) do
              row(0).background_color = 'CCCCCC'
              columns(0..4).align = :center
              cells.borders = []
            end
            pdf.move_down 10
            # Linha com o total do carrinho do cliente
            pdf.text "VALOR TOTAL DO PEDIDO: #{number_to_currency(cart.total, unit: "R$", separator: ",", delimiter: ".")}", style: :bold, align: :right
            pdf.move_down 10
            pdf.stroke_horizontal_rule
        end

        pdf.move_down 10
        pdf.text "Total do Dia: #{number_to_currency(total_total, unit: "R$", separator: ",", delimiter: ".")}",size: 16, style: :bold, align: :right
        pdf.move_down 10
        pdf.stroke_horizontal_rule

      end
      send_data pdf.render, filename: 'carts_report.pdf', type: 'application/pdf', disposition: 'inline'
    end

    def download_pdf
        @orderables = Orderable.all
        @carts = Cart.where(date: params[:date])
        pdf = Prawn::Document.new
        table_data = [['Cliente', 'Produto', 'Quantidade', 'Valor do Produto', 'Valor Total']]
        pdf.text 'RELATÓRIO GERAL DE VENDAS', size: 30, style: :bold

          pdf.text "Cliente: #{sales.client.name} | Produto: #{sales.product.name} | Quantidade: #{sales.quantity} | Valor: #{sales.total_value}" , style: :bold

          sales.each do |sales|
            [
              sales.client.name,
              sales.product.name,
              sales.quantity,
              sales.total_value
            ]
          end

        send_data(pdf.render,
                  filename: 'vendas_geral.pdf',
                  type: 'application/pdf')
    end

    def show_sale
        @cart = Cart.find_by(id:params[:cart_id])
    end

    private

  # Helper method to format numbers as currency
  def number_to_currency(number, options = {})
    unit      = options[:unit]      || "R$"
    separator = options[:separator] || ","
    delimiter = options[:delimiter] || "."
    format("%s %0.2f", unit, number).gsub(".", separator).gsub(/(\d)(?=(\d{3})+(?!\d))/, "\\1#{delimiter}")
  end
end
