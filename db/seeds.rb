# 管理者権限を持つユーザーの作成
admin = User.create(name: 'admin', email: 'admin@example.com', admin: true,
                    password: 'password', password_confirmation: 'password')

# テスト権限を持つユーザーの作成
User.create(name: 'test', email: 'test@example.com', test: true,
            password: 'password', password_confirmation: 'password')

# その他ユーザーの作成
20.times do |i|
  user = User.create(name: i.to_s, email: "#{i}@example.com",
                     password: 'password', password_confirmation: 'password')
  user.follow!(admin)
  admin.follow!(user)
end
