M = {}

-- Node defines a node in our calltree
-- Each Node describes a source code symbol
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
--
-- because this is a deep equal it confirms
-- all children are equal between the provided
-- roots as well.
function M.Node.eq(a, b)
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
-- 
-- {
--    0 = {Node},
--    1 = {Node}, {Node},
--    2 = {Node}, {Node}, {Node},
--    etc...
-- }
-- 
-- Where the integers represent the depth of the tree
-- each Node in the associated array exists.
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

    -- recursive search for parent node
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

local function _recursive_dpt_compute(node)
    local depth = node.depth
    if M.depth_table[depth] == nil then
        M.depth_table[depth] = {}
    end
    table.insert(M.depth_table[depth], node)
    -- recurse
    for _, child in ipairs(node.children) do
        _recursive_dpt_compute(child)
    end
end

local function _refresh_dpt()
    M.depth_table = {}
    _recursive_dpt_compute(M.root_node)
end

-- remove node will recursive delete any node
-- in the tree which represent the provided symbols.
--
-- deleting a node will knock out it's entire subtree.
--
-- symbols : string array - a list of symbols to delete from
-- the call tree.
function M.remove_node(symbols)
    local function recursive_delete(node)
        local tree_delete_indexes = {}
        for i, child in ipairs(node.children) do
            -- first check if this node matches
            -- any of the symbols to delete.
            --
            -- if so, mark their position, we'll
            -- remove them from the children array
            -- on the way back up the tree.
            for _, symbol in ipairs(symbols) do
                if child.name == symbol then
                    table.insert(tree_delete_indexes, i)
                    goto skip_recursion
                end
            end
            -- this node will not be deleted so
            -- recurse to check it's children
            recursive_delete(child)
            ::skip_recursion::
        end
        for _, tree_delete_i in ipairs(tree_delete_indexes) do
            -- delete from node's children array
            table.remove(node.children, tree_delete_i)
        end
    end
    recursive_delete(M.root_node)
    -- refresh the depth_table
    _refresh_dpt()
end

return M
