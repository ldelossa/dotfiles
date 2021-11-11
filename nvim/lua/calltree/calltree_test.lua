local tree = require('calltree.tree')

local function test_err(line, got, want)
    vim.api.nvim_err_writeln("line[" .. line .. "] got: " .. got .. ", want: " .. want .. " ❌")
end

local function test_calltree_add()
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

local function test_calltree_remove()
    print("Running: Test_calltree_remove")
    -- create the followig tree and delete Func2
    --                Func1
    --                /   \
    --           Func2     Func3
    --           /   \     /    \
    --      Func4 Func5    Func6 Func2
    --
    local root="Func1"
    local root_children={"Func2", "Func3"}
    local depth_2_child_1_children={"Func4", "Func5"}
    local depth_2_child_2_children={"Func6", "Func2"}
    tree.add_node(0, root, root_children)
    tree.add_node(1, "Func2", depth_2_child_1_children)
    tree.add_node(1, "Func3", depth_2_child_2_children)

    tree.remove_node({"Func2"})

    -- create want_root to test against our deletion
    local want_root = tree.Node.new("Func1", 0)
    local want_child_1 = tree.Node.new("Func3", 1)
    local want_child_2 = tree.Node.new("Func6", 2)
    table.insert(want_root.children, want_child_1)
    table.insert(want_child_1.children, want_child_2)

    local tree_root = tree.root_node
    if not tree_root == want_root then
        test_err(debug.getinfo(1).currentline, vim.inspect(tree_root), vim.inspect(want_root))
        return
    end

    -- check depth table
    if #M.depth_table[0] ~= 1 then
        test_err(debug.getinfo(1).currentline, #M.depth_table[0], 1)
        return
    end
    if #M.depth_table[1] ~= 1 then
        test_err(debug.getinfo(1).currentline, #M.depth_table[1], 1)
        return
    end
    if #M.depth_table[2] ~= 1 then
        test_err(debug.getinfo(1).currentline, #M.depth_table[2], 1)
        return
    end

    if not M.depth_table[0][1] == want_root then
        test_err(debug.getinfo(1).currentline, vim.inspect(M.depth_table[0][1]), vim.inspect(want_root))
        return
    end
    if not M.depth_table[1][1] == want_child_1 then
        test_err(debug.getinfo(1).currentline, vim.inspect(M.depth_table[1][1]), vim.inspect(want_child_1))
        return
    end
    if not M.depth_table[2][1] == want_child_2 then
        test_err(debug.getinfo(1).currentline, vim.inspect(M.depth_table[2][1]), vim.inspect(want_child_2))
        return
    end

    print("Test_calltree_remove ✅")
end

-- run suite
test_calltree_add()
test_calltree_remove()
