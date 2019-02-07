#!/bin/sh
# Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
#
# You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
# copy, modify, and distribute this software in source code or binary form for use
# in connection with the web services and APIs provided by Facebook.
#
# As with any software that integrates with the Facebook platform, your use of
# this software is subject to the Facebook Developer Principles and Policies
# [http://developers.facebook.com/policy/]. This copyright notice shall be
# included in all copies or substantial portions of the software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# shellcheck disable=SC2039
# shellcheck disable=SC1090

# --------------
# Functions
# --------------

# Main
main() {
  TEST_FAILURES=$((0))

  test_shared_setup
  test_run_routing
  test_is_valid_semver
  test_find_git_tag

  case $TEST_FAILURES in
  0) test_success "test_scripts tests" ;;
  *) test_failure "$TEST_FAILURES test_scripts tests" ;;
  esac
}

# Test Success
test_success() {
  local green='\033[0;32m'
  local none='\033[0m'
  echo "${green}* Passed:${none} $*"
}

# Test Failure
test_failure() {
  local red='\033[0;31m'
  local none='\033[0m'
  echo "${red}* Failed:${none} $*"
}

# Test Shared Setup
test_shared_setup() {

  # Arrange
  local test_sdk_kits=(
    "FBSDKCoreKit"
    "FBSDKLoginKit"
    "FBSDKShareKit"
    "FBSDKPlacesKit"
    "FBSDKMarketingKit"
    "FBSDKTVOSKit"
    "AccountKit"
  )

  local test_pod_specs=(
    "FacebookSDK.podspec"
    "FBSDKCoreKit.podspec"
    "FBSDKLoginKit.podspec"
    "FBSDKShareKit.podspec"
    "FBSDKPlacesKit.podspec"
    "FBSDKMarketingKit.podspec"
    "FBSDKTVOSKit.podspec"
    "AccountKit.podspec"
  )

  local test_version_change_files=(
    "Configurations/Version.xcconfig"
    "FBSDKCoreKit/FBSDKCoreKit/FBSDKCoreKit.h"
    "AccountKit/AccountKit/Internal/AKFConstants.m"
  )

  local test_main_version_file="Configurations/Version.xcconfig"

  if [ ! -f "$PWD/scripts/run.sh" ]; then
    test_failure "You're not in the correct working directory. Please change to the scripts/ parent directory"
  fi

  # Act
  . "$PWD/scripts/run.sh"

  # Assert
  if [ -z "$SCRIPTS_DIR" ]; then
    test_failure "SCRIPTS_DIR"
    ((TEST_FAILURES += 1))
  fi

  if [ "$SCRIPTS_DIR" != "$SDK_DIR"/scripts ]; then
    test_failure "SCRIPTS_DIR not correct"
    ((TEST_FAILURES += 1))
  fi

  if [ "${SDK_KITS[*]}" != "${test_sdk_kits[*]}" ]; then
    test_failure "SDK_KITS not correct"
    ((TEST_FAILURES += 1))
  fi

  if [ "${POD_SPECS[*]}" != "${test_pod_specs[*]}" ]; then
    test_failure "POD_SPECS not correct"
    ((TEST_FAILURES += 1))
  fi

  if [ "${VERSION_FILES[*]}" != "${test_version_change_files[*]}" ]; then
    test_failure "VERSION_FILES not correct"
    ((TEST_FAILURES += 1))
  fi

  if [ "$MAIN_VERSION_FILE" != "$test_main_version_file" ]; then
    test_failure "MAIN_VERSION_FILE not correct"
    ((TEST_FAILURES += 1))
  fi

  if [ "$FRAMEWORK_NAME" != "FacebookSDK" ]; then
    test_failure "FRAMEWORK_NAME not correct"
    ((TEST_FAILURES += 1))
  fi
}

test_is_valid_semver() {
  # Arrange
  local proper_versions=(
    "0.0.0"
    "1.0.0"
    "0.1.0"
    "0.0.1"
    "0.1.1"
    "10.1.0"
    "100.1.0"
    "10.10.10"
    "1.9.0"
    "1.10.0"
    "1.11.0"
    "1.0.0-alpha"
    "1.0.0-alpha.1"
    "1.0.0-0.3.7"
    "1.0.0-x.7.z.92"
    "1.0.0-alpha+001"
    "1.0.0+alpha-001"
    "1.0.0+20130313144700"
    "1.0.0-beta+exp.sha.5114f85"
    "1.0.0-alpha"
    "1.0.0-alpha.1"
    "1.0.0-alpha.beta"
    "1.0.0-beta"
    "1.0.0-beta.2"
    "1.0.0-beta.11"
    "1.0.0-rc.1"
  )

  # Act
  for version in "${proper_versions[@]}"; do
    # Assert
    if ! sh "$PWD"/scripts/run.sh is-valid-semver "$version"; then
      test_failure "$version is valid, but returns false"
      ((TEST_FAILURES += 1))
    fi
  done

  # Arrange
  local improper_versions=(
    "1.0."
    "0.1"
    "10.1.0.1"
    "a.b.c"
    "1.0.0-"
    "01.0.0"
    "00.0.0"
    "1.01.0"
    "0.00.0"
    "1.0.00"
    "0.0.01"
  )

  # Act
  for version in "${improper_versions[@]}"; do
    # Assert
    if sh "$PWD"/scripts/run.sh is-valid-semver "$version"; then
      test_failure "$version is invalid, but returns true"
    fi
  done
}

# Test Build SDK
test_run_routing() {
  # Arrange
  local inputs=(
    "build unsupported"
    "lint unsupported"
    "release unsupported"
    "help"
    ""
    "unsupported"
  )

  local expected=(
    "Unsupported Build: unsupported"
    "Unsupported Lint: unsupported"
    "Unsupported Release: unsupported"
    "Check main() for supported commands"
    "Check main() for supported commands"
    "Check main() for supported commands"
  )

  # Act
  for i in "${!inputs[@]}"; do
    local input_string="${inputs[$i]}"
    IFS=" " read -r -a input_params <<<"$input_string"

    local actual
    actual=$(sh "$PWD"/scripts/run.sh "${input_params[@]}")

    # Assert
    if [ "$actual" != "${expected[$i]}" ]; then
      test_failure "expected: ${expected[$i]} but got: $actual"
      ((TEST_FAILURES += 1))
    fi
  done
}

test_find_git_tag() {
  # Arrange, Act, & Assert
  if ! sh "$PWD"/scripts/run.sh does-version-exist 4.40.0; then
    test_failure "4.40.0 is valid, but returns false"
    ((TEST_FAILURES += 1))
  fi

  if sh "$PWD"/scripts/run.sh does-version-exist 0.0.0; then
    test_failure "0.0.0 is valid, but returns true"
    ((TEST_FAILURES += 1))
  fi
}

# --------------
# Main Script
# --------------

main "$@"
