module LinkedIn
  module Api
    autoload :QueryMethods,  "linked_in/api/query_methods"
    autoload :UpdateMethods, "linked_in/api/update_methods"
    autoload :GroupMethods,  "linked_in/api/group_methods"
    autoload :PostMethods,   "linked_in/api/post_methods"
    autoload :CommentMethods,"linked_in/api/comment_methods"
    autoload :CompanySearchMethods, "linked_in/api/company_search_methods"
    autoload :PeopleSearchMethods, "linked_in/api/people_search_methods"
  end
end
