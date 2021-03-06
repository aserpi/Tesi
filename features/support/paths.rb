module NavigationHelpers
  def path_to(page_name)
    case page_name
    when /^home$/
      '/'

    when /^(Admin|Consumer) sign (in|out|up)$/
      "/auth/#{Regexp.last_match(1).downcase.pluralize}/sign_#{Regexp.last_match(2)}"

    when /^(Employee|Operator|Supervisor) sign (in|out)$/
      "/auth/employees/sign_#{Regexp.last_match(2)}"

    when /^(Admin|Consumer|Employee) (.*)'s profile page$/
      "/auth/#{Regexp.last_match(1).downcase.pluralize}/#{Regexp.last_match(2)}"

    when /^new (Admin|Enterprise|Product)$/
      "/#{Regexp.last_match(1).downcase.pluralize}/new"

    when /^new (Employee|Operator|Supervisor)$/
      '/employees/new'

    when /^edit (Admin|Employee|Enterprise) "(.*)"$/
      "/#{Regexp.last_match(1).downcase.pluralize}/#{Regexp.last_match(2)}/edit"

    when /^edit (Advice|Problem) Thread$/
      klass = "#{Regexp.last_match(1).downcase}_thread"
      "#{klass}s/#{instance_variable_get("@#{klass}").id}/edit"

    when /^Enterprise (main|products)$/
      "/enterprises/#{@enterprise.name}/#{'/products' if Regexp.last_match(1) == 'products'}"

    when /^Facebook connect$/
      '/auth/consumers/auth/facebook'

    when /^Facebook disconnect$/
      '/auth/consumers/facebook/disconnect'

    when /^Product main$/
      "products/#{@product.id}"

    when /^Product (AdviceThread|ProblemThread)s$/
      "products/#{@product.id}/#{Regexp.last_match(1).underscore.pluralize}"

    when /^new (ProblemThread|AdviceThread)$/
      "/products/#{@product.id}/#{Regexp.last_match(1).underscore.pluralize}/new"

    when /^(ProblemThread|AdviceThread) (main|Downvotes)$/
      klass = Regexp.last_match(1).underscore
      "/#{klass.pluralize}/#{instance_variable_get("@#{klass}").id}/#{'down_votes' if Regexp.last_match(2) == 'Downvotes'}"

    when /^new (ProblemThread|AdviceThread) Comment$/
      klass = Regexp.last_match(1).underscore
      "/#{klass.pluralize}/#{instance_variable_get("@#{klass}").id}/comments/new"

    when(/^new (AdviceThread|Comment|ProblemThread) Downvote$/)
      klass = Regexp.last_match(1).underscore
      "/#{klass.pluralize}/#{instance_variable_get("@#{klass}").id}/down"

    when /^edit Comment$/
      "/comments/#{@comment.id}/edit"

    else
      begin
        page_name =~ /(.*)/
        path_components = Regexp.last_match(1).split(/\s+/)
        send(path_components.push('path').join('_').to_sym)
      rescue Object => _e
        raise "Can't find mapping from \\\"#{page_name}\\\" to a path.\\nNow, go and add a mapping in #{__FILE__}"
      end
    end
  end

  def settings_path_to(res)
    if res.is_a?(Admin) || res.is_a?(Employee)
      "/#{res.class.name.downcase.pluralize}/#{res.username}/edit"
    elsif res.is_a? Consumer
      '/auth/consumers/edit'
    elsif res.is_a? Enterprise
      "/enterprises/#{res.name}/edit"
    elsif res.is_a? Product
      "/products/#{res.id}/edit"
    elsif res.is_a?Comment
      "/comments/#{res.id}/edit"
    end
  end
end

World(NavigationHelpers)
