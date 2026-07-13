{% extends "base.html" %}
{% block title %}Branches{% endblock %}
{% block page_title %}Bank Branches{% endblock %}
{% block content %}
<div class="card">
    <div class="card-header"><h2><i class="fas fa-building"></i> All Branches</h2><span class="badge">{{ branches|length }}</span></div>
    <div class="card-body">
        <div class="branches-grid">
            {% for b in branches %}
            <div class="branch-card">
                <div class="branch-icon"><i class="fas fa-building"></i></div>
                <h3>{{ b.branch_name }}</h3>
                <p class="branch-code"><code>{{ b.branch_code }}</code></p>
                <div class="branch-info">
                    <div><i class="fas fa-university"></i> {{ b.bank_name }}</div>
                    <div><i class="fas fa-map-marker-alt"></i> {{ b.address }}, {{ b.city }}</div>
                    <div><i class="fas fa-phone"></i> {{ b.phone }}</div>
                    <div><i class="fas fa-user-tie"></i> {{ b.employee_count }} Employee(s)</div>
                </div>
            </div>
            {% else %}
            <p class="empty-row">No branches found.</p>
            {% endfor %}
        </div>
    </div>
</div>
{% endblock %}
