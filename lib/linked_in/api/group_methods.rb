module LinkedIn
  module Api
    module GroupMethods
      
      def groups(options={})
        path = "#{person_path(options)}/group-memberships?membership-state=member"
        group_mash = simple_query(path, options)
        group_mash.all
      end

    end # GroupMethods
  end # Api
end # LinkedIn
