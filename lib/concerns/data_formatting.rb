module DataFormatting
  def undelta(delta)
    delta = JSON.parse(delta)
    entries = delta["ops"]
    html = ""
    i = 0
    while i < entries.length
      if !!entries[i + 1] && !!entries[i + 1]["attributes"] && !!entries[i]["insert"] && !!entries[i + 1]["attributes"]["header"]
          content = "<h#{entries[i + 1]["attributes"]["header"]}>#{entries[i]["insert"]}</h#{entries[i + 1]["attributes"]["header"]}>"
        #lists
      elsif !!entries[i + 1] && !!entries[i + 1]["attributes"] && entries[i]["insert"] && entries[i + 1]["attributes"]["list"]
          content = ""
          if !!entries[i + 1] && !!entries[i + 1]["attributes"]
            if !!entries[i - 1] && !!entries[i - 1]["attributes"] && !entries[i - 1]["attributes"]["list"]
              content << "<ul><li>#{entries[i]["insert"]}</li>"
            elsif !!entries[i + 3] && !!entries[i + 3]["attributes"] && !entries[i + 3]["attributes"]["list"]
                content << "<li>#{entries[i]["insert"]}</li></ul>"
            elsif !entries[i + 2]
              content << "<li>#{entries[i]["insert"]}</li></ul>"
            else
              content << "<li>#{entries[i]["insert"]}</li>"
            end
          end
      elsif entries[i]["insert"] && entries[i]["attributes"] && !(!!entries[i]["attributes"]["list"] || (!!entries[i + 1] && !!entries[i + 1]["attributes"] && !!entries[i + 1]["attributes"]["list"])) && !entries[i]["insert"].empty?
        open = ""
        close = []
        if entries[i]["attributes"]["bold"]
          open << "<b>"
          close << "</b>"
        end
        if entries[i]["attributes"]["italic"]
          open << "<i>"
          close << "</i>"
        end
        if entries[i]["attributes"]["underline"]
          open << "<u>"
          close << "</u>"
        end
        content = open + entries[i]["insert"] + close.reverse().join("")
      else
        content = entries[i]["insert"]
      end
        html << content
      i+=1
    end
    html.gsub("\n", "<br>").gsub("<p></p>","").gsub("<script","").gsub("</script>","")
  end
end
