module ApplicationHelper
  def cc_html(options={}, &blk)
    attrs = options.map { |(k, v)| " #{h k}='#{h v}'" }.join('')
    [ "<!--[if lt IE 7 ]> <html#{attrs} class='ie ie6 no-js'> <![endif]-->",
      "<!--[if IE 7 ]>    <html#{attrs} class='ie ie7 no-js'> <![endif]-->",
      "<!--[if IE 8 ]>    <html#{attrs} class='ie ie8 no-js'> <![endif]-->",
      "<!--[if IE 9 ]>    <html#{attrs} class='ie ie9 no-js'> <![endif]-->",
      "<!--[if gt IE 9]><!--><html#{attrs} class='no-js'> <!--<![endif]-->",
      capture_haml(&blk).strip,
      "</html>"
    ].join("\n").html_safe
  end
  def h(str); Rack::Utils.escape_html(str); end

  AVAILABLE_LOCALES = %w{en jp}

  def img_lang_links
    AVAILABLE_LOCALES.map { |k|
      current = params[:locale] == k ? "current" : ''
        link_to_if(k, "", root_path(:locale => k), {:class => "#{k} #{current}", :rel => "nofollow"})
    }.join('&nbsp; ').html_safe
  end
end
