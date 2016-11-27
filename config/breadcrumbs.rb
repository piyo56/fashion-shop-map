# Root crumb
crumb :root do
  link "トップ", root_path
end

# showing map page
crumb :show do
  link "店舗検索・表示", show_path
  parent :root
end

# service about page
crumb :about do
  link "本サービスについて", about_path
  parent :root
end

# sending a inquiry page
crumb :inquiry do
  link "ご意見・ご要望", inquiry_path
  parent :root
end
crumb :inquiry_confirm do
  link "送信内容の確認", inquiry_confirm_path
  parent :inquiry
end
crumb :inquiry do
  link "送信完了", inquiry_thanks_path
  parent :inquiry
end


# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
