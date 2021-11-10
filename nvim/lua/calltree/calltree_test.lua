local tree = require('calltree.tree')

local function test_err(line, got, want)
    vim.api.nvim_err_writeln("line[" .. line .. "] got: " .. got .. ", want: " .. want .. " ❌")
end

function Test_calltree_add()
    print("Running: Test_calltree_add")
    -- insert a new root with some children, check
    -- tree and depth_table
    local depth=0
    local parent="Func1"
    local children={"Func2", "Func3"}
    tree.add_node(depth, parent, children)

    local want_child1 = tree.Node.new("Func2", 1)
    local want_child2 = tree.Node.new("Func3", 1)
    local want_root   = tree.Node.new("Func1", 0)
    table.insert(want_root.children, want_child1)
    table.insert(want_root.children, want_child2)

    local tree_root = tree.root_node
    if not tree_root == want_root then
        test_err(debug.getinfo(1).currentline, vim.inspect(tree_root), vim.inspect(want_root))
        return
    end

    -- add two new children to Func2 node.
    print("Test_calltree_add - adding children to child1")
    local want_child3 = tree.Node.new("Func4", 2)
    local want_child4 = tree.Node.new("Func5", 2)
    table.insert(want_child1.children, want_child3)
    table.insert(want_child1.children, want_child4)

    children = {"Func4", "Func5"}
    tree.add_node(want_child1.depth, want_child1.name, children)
    if not tree_root == want_root then
        test_err(debug.getinfo(1).currentline, vim.inspect(tree_root), vim.inspect(want_root))
        return
    end
    print("Test_calltree_add ✅")
end
Test_calltree_add()

