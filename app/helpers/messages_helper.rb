module MessagesHelper
  def inline_users(users)
    users.map { |user| "#{user.name} (#{user.email}), " }.join(" ")[0...-2]
  end
end
