SAMPLE_PASSWORD = 'asdfghjklA1!'.freeze
ACCOUNTS_TO_CREATE = 10
RECORDS_TO_CREATE_PER_ACCOUNT = 10
SUBSCRIPTIONS_TO_CREATE = 5

def create_full_accounts(n)
  accounts = []
  n.times do
    random_string = SecureRandom.alphanumeric(10)
    user = User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", password: SAMPLE_PASSWORD,
                        password_confirmation: SAMPLE_PASSWORD, account_attributes: { nickname: SecureRandom.alphanumeric(10) }
    accounts.push(user.account)
  end
  accounts
end

def create_records(account, n = 5)
  records = []
  n.times do
    record = Record.create! account: account, creator: account.user, recordable: Link.create!(url: 'https://example.com')
    records.push(record)
  end
end

def create_subscription(from, to)
  Subscription.create! subscriber: from, subscribable: to unless from == to
end

accounts = create_full_accounts(ACCOUNTS_TO_CREATE)
records = accounts.each { |account| create_records(account, RECORDS_TO_CREATE_PER_ACCOUNT) }
subscriptions = accounts.first(ACCOUNTS_TO_CREATE / 2).each do |account|
  create_subscription(account, accounts[account.id + 2].records.first) if accounts[account.id + 2]
  create_subscription(account, accounts[account.id + 1]) if accounts[account.id + 1]
end
