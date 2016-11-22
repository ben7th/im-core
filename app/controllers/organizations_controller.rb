class OrganizationsController < ApplicationController
  def trees
    roots = OrganizationNode.roots.map { |x|
      { 
        id: x.id.to_s, 
        name: x.name,
        path: show_tree_organization_path(x)
      }
    }

    @component_name = 'OrganizationsTreesPage'
    @component_data = {
      tree_roots: roots
    }
  end

  def show_tree
    root = OrganizationNode.find(params[:id])

    @component_name = 'OrganizationTreePage'
    @component_data = {
      tree_data: root.tree_data
    }
  end

  def show
    o = OrganizationNode.find(params[:id])

    @component_name = 'OrganizationNodeShow'
    @component_data = {
      node_data: o.node_data
    }
  end
end