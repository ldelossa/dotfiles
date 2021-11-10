M = {}

-- Node defines a node in our calltree
-- Each node describes a source code symbol
-- capable of have it's incoming or outgoing
-- call hierarchy resolved via an LSP client.
M.Node = {}
M.Node.mt = {
    __eq = M.Node.eq
}

-- new construct a new node.
--
-- name : string - Name of the Node, this cooresponds
-- to it's symbol in the source code.
--
-- depth : int - the depth at which this node will exist
-- in the tree.
function M.Node.new(name, depth)
    local node = {
        name=name,
        depth=depth,
        children={},
    }
    setmetatable(node, M.Node.mt)
    return node
end

-- eq perfoms a deepequal operation
-- for two Nodes.
function M.Node.eq(a, b)
    print("here")
    if a.name ~= b.name then
        return false
    end
    if a.depth ~= b.depth then
        return false
    end
    if #a.children ~= #b.children then
        return false
    end
    for i, _ in ipairs(a.children) do
        -- recurse
        if not M.Node.eq(
            a.children[i],
            b.children[i]
        ) then
            return false
        end
    end
    return true
end

-- depth_table caches the depth at which
-- a Node in the tree exists.
--
-- this data structure looks as follows:
-- {
--   {
--      0 = {Node},
--      1 = {Node}, {Node},
--      2 = {Node}, {Node}, {Node},
--      etc...
--   }
-- }
-- Where the integers represent the depth of the tree
-- each Node exists.
M.depth_table = {}

-- root_node is the root of our call tree
-- all other Nodes will be a descendent of
-- this root.
M.root_node = {}

-- add_node will add the children to the
-- node specified by parent and depth.
--
-- depth : int - depth at which the parent
-- exists, used for quickly looking up the parent
-- in the depth_table
--
-- if depth=0 this signifies a new call tree will
-- be created with the given parent as root.
--
-- parent : string - the symbol name of the
-- parent we are attempting to add these children
-- for.
--
-- children : array of strings - a list of children
-- symbol names we will add to the parent.
function M.add_node(depth, parent, children)
    if depth == 0 then
        M.root_node = M.Node.new(parent, depth)
        M.depth_table = {}
        M.depth_table[0] = {}
        table.insert(M.depth_table[0], M.root_node)
    end

    -- we are adding children to an existing parent
    -- error out if the desired depth is ont in the table.
    if M.depth_table[depth] == nil then
        -- this is an error
        return
    end

    -- search depth_table for parent symbol
    local pNode = nil
    for _, node in pairs(M.depth_table[depth]) do
        if node.name == parent then
            pNode = node
            break
        end
    end

    -- add children to depth table
    if M.depth_table[depth+1] == nil then
        M.depth_table[depth+1] = {}
    end

    -- add children to parent and depth_table
    for _, child  in pairs(children) do
        local cNode = M.Node.new(child, depth+1)
        table.insert(pNode.children, cNode)
        table.insert(M.depth_table[depth+1], cNode)
    end
end

function M.remove_node(depth, parent)
end

return M
