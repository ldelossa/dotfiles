import lldb
import os

def __lldb_init_module(debugger, internal_dict):
    """
    The function that LLDB automatically calls to load this script.
    """
    debugger.HandleCommand('command script add -f scripts.set_breakpoint_command brp')
    print('The "brp" command has been installed. Use it by typing "brp /path/to/file:line".')

def set_breakpoint_command(debugger, command, result, internal_dict):
    """
    Parses the Delve-like breakpoint command and sets a breakpoint in LLDB.
    """
    # Split the command input into file path and line number
    try:
        file_path, line_str = command.split(':')
        line = int(line_str)
        breakpoint_command = f'breakpoint set --file "{file_path}" --line {line}'
        debugger.HandleCommand(breakpoint_command)
    except ValueError:
        print("Error: Invalid input format. Use '/path/to/file:line'.", file=result)

