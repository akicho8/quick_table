# -*- coding: utf-8 -*-
require 'test_helper'

class TestQuickTable < Test::Unit::TestCase
  setup do
    @view_context = ViewContext.new
    @object = QuickTable::Htmlizer.new(@view_context)
  end

  test "@object.htmlize" do
    assert_equal nil, @object.htmlize
  end

  test "ブロックで引数が一つ" do
    assert_equal "<div class=\"quick_table depth_0\"><table class=\"table\"><tbody><tr><td>a</td></tr></tbody></table></div>", @object.htmlize{:a}
  end

  test "ハッシュ" do
    assert_equal "<div class=\"quick_table depth_0\"><table class=\"table\"><tbody><tr><td>a</td><td>1</td></tr></tbody></table></div>", @object.htmlize(:a => 1)
  end

  test "ハッシュだとオプションは無視される(いいのか？)" do
    assert_equal "<div class=\"quick_table depth_0\"><table class=\"table\"><tbody><tr><td>a</td><td>1</td></tr></tbody></table></div>", @object.htmlize({:a => 1}, :o => 1)
  end

  test "普通に引数が一つ" do
    assert_equal "<div class=\"quick_table depth_0\"><table class=\"table\"><tbody><tr><td>a</td></tr></tbody></table></div>", @object.htmlize(:a)
  end

  test "ブロックで配列" do
    assert_equal "<div class=\"quick_table depth_0\"><table class=\"table\"><tbody><tr><td>a</td><td>1</td></tr></tbody></table></div>", @object.htmlize{[:a, 1]}
  end

  test "ブロックで要素の多い配列" do
    assert_equal "<div class=\"quick_table depth_0\"><table class=\"table\"><tbody><tr><td>a</td><td>1</td><td>b</td><td>2</td></tr></tbody></table></div>", @object.htmlize{[:a, 1, :b, 2]}
  end

  test "ブロックで複数の配列の配列" do
    assert_equal "<div class=\"quick_table depth_0\"><table class=\"table\"><tbody><tr><td>a</td><td>1</td></tr><tr><td>b</td><td>2</td></tr></tbody></table></div>", @object.htmlize{[[:a, 1], [:b, 2]]}
  end

  test "ブロックで複数のハッシュ" do
    assert_equal "<div class=\"quick_table depth_0\"><table class=\"table\"><tbody><tr><td>a</td><td>1</td></tr><tr><td>b</td><td>2</td></tr></tbody></table></div>", @object.htmlize{{:a => 1, :b => 2}}
  end

  test "ブロックで複数のハッシュ配列化？" do
    assert_equal "<div class=\"quick_table depth_0\"><table class=\"table\"><tbody><tr><td>a</td><td>1</td></tr><tr><td>b</td><td>2</td></tr></tbody></table></div>", @object.htmlize({:a => 1, :b => 2}.to_a)
  end

  test "複雑な配列" do
    assert_equal "<div class=\"quick_table depth_0\"><table class=\"table\"><tbody><tr><td>1</td><td><div class=\"quick_table depth_1\"><table class=\"table\"><tr><td>[2, 3]</td></tr></table></div></td></tr><tr><td><div class=\"quick_table depth_1\"><table class=\"table\"><tr><td>[4, 5]</td></tr></table></div></td><td>6</td></tr></tbody></table></div>", @object.htmlize{[[1,[2,3]], [[4,5],6]]}
  end

  test "each_with_object風な" do
    assert_equal "<div class=\"quick_table depth_0\"><table class=\"table\"><tbody><tr><td>1</td><td>2</td></tr></tbody></table></div>", @object.htmlize{|items|items << 1; items << 2}
  end

  test ":a, :b, :o => 1" do
    assert_equal "<div class=\"quick_table depth_0\"><table class=\"table\"><tbody><tr><td>a</td><td>b</td></tr></tbody></table></div>", @object.htmlize(:a, :b, :o => 1)
  end

  test "array_of_hash" do
    assert_equal "<div class=\"quick_table depth_0\"><table class=\"table\"><tbody><tr><td>a</td><td>b</td></tr><tr><td>1</td><td>2</td></tr><tr><td>3</td><td>4</td></tr></tbody></table></div>", @object.htmlize(:array_of_hash => true){[{:a => 1, :b => 2}, {:a => 3, :b => 4}]}
  end

  test "@view_context.quick_table" do
    assert_equal nil, @view_context.quick_table
  end
end
