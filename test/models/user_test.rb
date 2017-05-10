require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name:"example name", email:"hello@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end
  test "should be valid" do
   assert @user.valid?
  end
  test "name should not be blank" do
    @user.name = "   "
    assert_not @user.valid?
  end
  test "email should not be blank" do
    @user.email = " "
    assert_not @user.valid?
  end
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  test "email should not be too long" do
    @user.email = "a" * 244 + "example.com"
    assert_not @user.valid?
  end
  test "email validation should accept valid addresses" do
    valid_address = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    @user.email = valid_address
    assert @user.valid?, "#{valid_address.inspect} should be valid"
  end
  test "email validation should reject invalid addresses" do
    invalid_address = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    @user.email = invalid_address
    assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
  end
  test "uniqueness should be valid" do
    duplicate_user = @user.dup
    duplicate_user_email = @user.email.upcase
    @user.save
    assert_not duplicate_user_valid?
  end
  test "password should not be blank" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  test "password sholuld shave minimum characters" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
