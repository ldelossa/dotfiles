M = {}

-- Node represents a symbol in a
-- call tree.
M.Node = {}

M.Node.mt = {
    __eq = M.Node.eq
}

-- new construct a new Node.
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
        expanded=false
    }
    setmetatable(node, M.Node.mt)
    return node
end

-- eq perfoms a recursive comparison
-- between the two roots and their children.
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
--    0 = {{Node}}
--    1 = {{Node}, {Node}}
--    2 = {{Node}, {Node}, {Node}}
--    etc...
-- }
M.depth_table = {}

-- the root of the current call tree.
M.root_node = {}

-- add_node will add the children to the
-- node specified by parent and depth.
--
-- depth : int - depth at which the parent exists,
-- if this is 0 a new call tree will be created.
--
-- parent : string - symbol at which children are
-- to be added to the call tree hierarchy.
--
-- children : array of strings - the incoming
-- or outgoing symbols for the given parent symbol.
function M.add_node(depth, parent, children)
    -- if depth is 0 we are creating a new
    -- call tree.
    if depth == 0 then
        M.root_node = M.Node.new(parent, depth)
        M.depth_table = {}
        M.depth_table[0] = {}
        table.insert(M.depth_table[0], M.root_node)
    end

    -- if parent's depth doesn't exist we can't
    -- continue.
    if M.depth_table[depth] == nil then
        -- this is an error
        return
    end

    -- lookup parent node in depth tree (faster then then tree diving.)
    local pNode = nil
    for _, node in pairs(M.depth_table[depth]) do
        if node.name == parent then
            pNode = node
            break
        end
    end

    -- add children to parent node and update
    -- depth_table.
    if M.depth_table[depth+1] == nil then
        M.depth_table[depth+1] = {}
    end

    for _, child  in pairs(children) do
        local cNode = M.Node.new(child, depth+1)
        table.insert(pNode.children, cNode)
        table.insert(M.depth_table[depth+1], cNode)
    end
end

-- recursive_dpt_compute traverses the tree
-- and flattens it into out depth_table
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

-- _refresh_dpt dumps the current depth_table
-- and writes a new one.
local function _refresh_dpt()
    M.depth_table = {}
    _recursive_dpt_compute(M.root_node)
end

-- remove_node will remove all nodes associated
-- with the given symbols from the call tree and depth table
--
-- symbols : string array - a list of symbols to delete from
-- the call tree and depth table.
function M.remove_node(symbols)
    -- in order traversal of call tree
    local function recursive_delete(node)
        local tree_delete_indexes = {}
        for i, child in ipairs(node.children) do
            for _, symbol in ipairs(symbols) do
                -- if a child node matches a target
                -- symbol, record its index for deletion, and continue
                -- to next node without recursing.
                if child.name == symbol then
                    table.insert(tree_delete_indexes, i)
                    goto skip_recursion
                end
            end
            recursive_delete(child)
            ::skip_recursion::
        end
        -- recursion is done, we can safely delete any matching
        -- nodes from the children array.
        for _, tree_delete_i in ipairs(tree_delete_indexes) do
            table.remove(node.children, tree_delete_i)
        end
    end
    recursive_delete(M.root_node)
    _refresh_dpt()
end

return M
