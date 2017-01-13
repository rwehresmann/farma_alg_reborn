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

  # Returns a span tag with the right label.
  def question_status(question)
    if current_user.answered_correctly?(question)
      '<span class="badge bg-green">Correta</span>'
    elsif current_user.unanswered?(question)
      '<span class="badge bg-gray">Sem resposta</span>'
    else
      '<span class="badge bg-red text-center" style="width=70px">Errada</span>'
    end
  end

  # Returns a width property filled according user progress
  # (in the current template, progressbar is filled according the
  # width property, so it must be created dynamically).
  def progress(exercise)
    "width: #{exercise.user_progress(current_user)}%"
  end
end
