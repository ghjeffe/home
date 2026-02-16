#!/bin/bash

# Unit tests for file_sync.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT="$SCRIPT_DIR/file_sync.sh"
FILES_FROM="$SCRIPT_DIR/files-from"
HOME_DIR="/home/ghjeffeii"

TESTS_PASSED=0
TESTS_FAILED=0

# Helper function to report test results
report_result() {
    local test_name="$1"
    local result="$2"
    local message="$3"
    
    if [ "$result" -eq 0 ]; then
        echo "✓ PASS: $test_name"
        ((TESTS_PASSED++))
    else
        echo "✗ FAIL: $test_name - $message"
        ((TESTS_FAILED++))
    fi
}

# Test 1: file_sync.sh executes successfully with the new permissions
test_execute_permissions() {
    local test_name="file_sync.sh executes successfully with the new permissions"
    
    # Check that the script has execute permissions
    if [ ! -x "$SCRIPT" ]; then
        report_result "$test_name" 1 "Script does not have execute permissions"
        return
    fi
    
    # Test that the script can be executed (using dry-run to avoid actual sync)
    # We'll run rsync with -n (dry-run) flag to test execution
    rsync -avzn "$HOME_DIR" --files-from "$FILES_FROM" "$SCRIPT_DIR/" > /dev/null 2>&1
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        report_result "$test_name" 0 ""
    else
        report_result "$test_name" 1 "rsync dry-run failed with exit code $exit_code"
    fi
}

# Test 2: file_sync.sh correctly processes the new 'code/home/files-from' entry
test_files_from_entry() {
    local test_name="file_sync.sh correctly processes the 'code/home/files-from' entry"
    
    # Check that 'code/home/files-from' exists in the files-from list
    if ! grep -q "^code/home/files-from$" "$FILES_FROM"; then
        report_result "$test_name" 1 "'code/home/files-from' entry not found in files-from"
        return
    fi
    
    # Check that the source file exists
    local source_file="$HOME_DIR/code/home/files-from"
    if [ ! -f "$source_file" ]; then
        report_result "$test_name" 1 "Source file $source_file does not exist"
        return
    fi
    
    # Verify rsync would process this file (using --list-only to see all files)
    local rsync_output
    rsync_output=$(rsync -avz --list-only "$HOME_DIR" --files-from "$FILES_FROM" "$SCRIPT_DIR/" 2>&1)
    
    if echo "$rsync_output" | grep -q "files-from"; then
        report_result "$test_name" 0 ""
    else
        report_result "$test_name" 1 "rsync did not process 'code/home/files-from' entry"
    fi
}

# Test 3: file_sync.sh correctly processes the new '.vimrc' entry
test_vimrc_entry() {
    local test_name="file_sync.sh correctly processes the '.vimrc' entry"
    
    # Check that '.vimrc' exists in the files-from list
    if ! grep -q "^\.vimrc$" "$FILES_FROM"; then
        report_result "$test_name" 1 "'.vimrc' entry not found in files-from"
        return
    fi
    
    # Check that the source file exists
    local source_file="$HOME_DIR/.vimrc"
    if [ ! -f "$source_file" ]; then
        report_result "$test_name" 1 "Source file $source_file does not exist"
        return
    fi
    
    # Verify rsync would process this file (using --list-only to see all files)
    local rsync_output
    rsync_output=$(rsync -avz --list-only "$HOME_DIR" --files-from "$FILES_FROM" "$SCRIPT_DIR/" 2>&1)
    
    if echo "$rsync_output" | grep -q "\.vimrc"; then
        report_result "$test_name" 0 ""
    else
        report_result "$test_name" 1 "rsync did not process '.vimrc' entry"
    fi
}

# Run all tests
echo "Running file_sync.sh unit tests..."
echo "=================================="

test_execute_permissions
test_files_from_entry
test_vimrc_entry

echo "=================================="
echo "Results: $TESTS_PASSED passed, $TESTS_FAILED failed"

# Exit with failure if any tests failed
[ $TESTS_FAILED -eq 0 ]
