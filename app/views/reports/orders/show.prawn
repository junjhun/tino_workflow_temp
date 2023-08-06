prawn_document(info: { Title: "@person.full_name_ordered" }) do |pdf|  
    pdf.move_down 30
  
    header = [
      ["1", "2"],
      ["1", "2"]
    ]
  
    pdf.table(header) do
      cells.borders = [:left, :right, :top, :bottom]
      column(0..1).width = 180
  
      row(0..5).style font_style: :bold
      cells.style(:padding => 0, :border_width => 2)
    end    

end

# .style(:padding => 0, :border_width => 2)
# cells.style size: 10
