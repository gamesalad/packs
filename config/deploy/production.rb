# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :app, %w{packimg-deploy@54.173.51.223}
role :web, %w{packimg-deploy@54.173.51.223}
role :db,  %w{packimg-deploy@54.173.51.223}
