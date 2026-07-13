{% extends "base.html" %}
{% block title %}Customer Detail{% endblock %}
{% block page_title %}Customer Profile{% endblock %}

{% block content %}
<div class="page-actions">
    <a href="{{ url_for('customers') }}" class="btn btn-secondary">
        <i class="fas fa-arrow-left"></i> Back
    </a>
</div>

{% if customer %}
<div class="profile-grid">
    <div class="card profile-card">
        <div class="card-body center">
            <div class="profile-avatar">{{ customer.first_name[0] }}{{ customer.last_name[0] }}</div>
            <h2>{{ customer.first_name }} {{ customer.last_name }}</h2>
            <p class="text-muted">{{ customer.bank_name }}</p>
            <div class="info-rows">
                <div class="info-row"><i class="fas fa-envelope"></i> {{ customer.email }}</div>
                <div class="info-row"><i class="fas fa-phone"></i> {{ customer.phone }}</div>
                <div class="info-row"><i class="fas fa-map-marker-alt"></i> {{ customer.address }}</div>
                <div class="info-row"><i class="fas fa-birthday-cake"></i> {{ customer.date_of_birth }}</div>
                <div class="info-row"><i class="fas fa-id-card"></i> {{ customer.national_id }}</div>
            </div>
        </div>
    </div>

    <div class="detail-right">
        <div class="card">
            <div class="card-header">
                <h2><i class="fas fa-credit-card"></i> Accounts ({{ accounts|length }})</h2>
                <a href="{{ url_for('add_account') }}" class="btn-sm btn-view">+ Add</a>
            </div>
            <div class="card-body">
                {% for a in accounts %}
                <div class="account-row {% if a.account_type == 'saving' %}saving{% else %}current{% endif %}">
                    <div>
                        <strong>{{ a.account_number }}</strong>
                        <span class="type-badge">{{ a.account_type|capitalize }}</span>
                    </div>
                    <div class="account-balance">৳ {{ "{:,.2f}".format(a.balance) }}</div>
                    <div>
                        {% if a.interest_rate %}
                        <small>Interest: {{ a.interest_rate }}%</small>
                        {% elif a.overdraft_limit %}
                        <small>Overdraft: ৳{{ "{:,.0f}".format(a.overdraft_limit) }}</small>
                        {% endif %}
                        <span class="status-{{ a.status }}">{{ a.status }}</span>
                    </div>
                </div>
                {% else %}
                <p class="empty-row">No accounts yet.</p>
                {% endfor %}
            </div>
        </div>

        <div class="card mt-3">
            <div class="card-header">
                <h2><i class="fas fa-hand-holding-usd"></i> Loans ({{ loans|length }})</h2>
                <a href="{{ url_for('add_loan') }}" class="btn-sm btn-view">+ Apply</a>
            </div>
            <div class="card-body">
                {% for l in loans %}
                <div class="loan-row">
                    <div>
                        <strong>{{ l.loan_type }}</strong>
                        <span class="status-{{ l.status }}">{{ l.status }}</span>
                    </div>
                    <div>Amount: <strong>৳ {{ "{:,.0f}".format(l.loan_amount) }}</strong></div>
                    <div>Paid: ৳ {{ "{:,.0f}".format(l.total_paid) }} | Rate: {{ l.interest_rate }}%</div>
                    <a href="{{ url_for('add_payment', loan_id=l.loan_id) }}" class="btn-sm btn-view">
                        <i class="fas fa-money-bill"></i> Payments
                    </a>
                </div>
                {% else %}
                <p class="empty-row">No loans.</p>
                {% endfor %}
            </div>
        </div>
    </div>
</div>
{% endif %}
{% endblock %}
