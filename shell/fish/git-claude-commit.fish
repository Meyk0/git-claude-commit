function git-claude-commit
    # Check if the command exists
    if not command -v git-claude-commit >/dev/null
        echo "Error: git-claude-commit not found. Please install it first."
        return 1
    end

    # Pass all arguments to the git-claude-commit script
    command git-claude-commit $argv
end

# Add completion support
complete -c git-claude-commit -s y -l yes -d "Automatically accept the generated message"
complete -c git-claude-commit -s e -l edit -d "Open editor to modify the generated message"
complete -c git-claude-commit -s m -l model -r -d "Specify Claude model to use"
complete -c git-claude-commit -s v -l verbose -d "Show detailed output"
complete -c git-claude-commit -s h -l help -d "Show help message" 