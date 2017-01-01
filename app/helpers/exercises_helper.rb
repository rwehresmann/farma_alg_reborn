module ExercisesHelper
  # 'CodeRayify' class implementation taken from
  # http://allfuzzy.tumblr.com/post/27314404412/markdown-and-code-syntax-highlighting-in-ruby-on
  class CodeRayify < Redcarpet::Render::HTML
    def block_code(code, language)
      CodeRay.scan(code, language).div(:line_numbers => :table)
    end
  end

  # Display in markdown ("prettified").
  def markdown(text)
    coderayified = CodeRayify.new(no_images: true)

    extensions = { hard_wrap: true, filter_html: true, autolink: true,
                   no_intraemphasis: true, fenced_code_blocks: true,
                   tables: true, superscript: true }

    markdown = Redcarpet::Markdown.new(coderayified, extensions)
    markdown.render(text).html_safe
  end

  # Pluralize question text.
  def pluralize_questions(count)
    return "#{count} questões cadastradas" if count >= 0
    "#{count} questão cadastrada"
  end
end
