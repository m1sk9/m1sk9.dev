+++
title = "babyrite: Privacy Policy"
description = "Detailed Information about babyrite Privacy Policy"
template = "prose.html"

[extra]
title = "babyrite: Privacy Policy"
description = "Detailed Information about babyrite Privacy Policy"
+++

> This page is in English.
>
> 日本語版は [こちら](/babyrite/privacy) からアクセスできます。

**Last Updated: February 17, 2026**

## 1. Introduction

This Privacy Policy explains how babyrite (the "Bot") collects, uses, and protects information when you use it on your Discord server.

**Important**: babyrite is designed with privacy in mind and collects only the **minimum data** necessary for its core functionality.

## 2. Information We Collect

### 2.1 Information We Process (Not Permanently Stored)

The Bot **temporarily** processes the following information to provide its services:

#### Discord Message Content
- **What**: Message text containing Discord message links or GitHub permalinks
- **Why**: To detect and expand links into previews
- **Duration**: Processed in real-time, not permanently stored
- **Scope**: Only messages in channels the Bot has access to

#### Message Metadata
- **What**: Message ID, channel ID, guild ID, user ID, timestamp
- **Why**: To accurately retrieve and display message previews
- **Duration**: Processed in real-time, not permanently stored

#### User Information (from Discord API)
- **What**: Username, avatar URL, bot flags
- **Why**: To display author information in message previews
- **Duration**: Retrieved on-demand, not permanently stored

### 2.2 Cached Data (Temporary Storage)

The Bot temporarily caches the following data for performance optimization:

#### Guild Channel Information
- **What**: Channel name, channel ID, guild ID, channel type (text/voice/thread), NSFW flag
- **Why**: To avoid repeated API calls and improve response times
- **Duration**: Cached for up to 12 hours, automatically cleaned up
- **Storage**: In-memory cache (moka cache library)
- **Scope**: Only guilds where the Bot is active

**Important**: Server and channel metadata (names, IDs, settings) are temporarily cached in memory for performance. This cache is not saved to persistent storage and is automatically purged regularly.

**Cache Configuration:**
- **Time to Live (TTL)**: 12 hours from insertion
- **Time to Idle (TTI)**: 1 hour of inactivity
- **Maximum Capacity**: 500 entries (older entries are automatically evicted)

### 2.3 Information We Do NOT Collect

The Bot does **not** collect, store, or transmit:

- ✗ Message content beyond real-time processing
- ✗ Private messages (DMs)
- ✗ Messages from NSFW channels
- ✗ Messages from private channels or threads
- ✗ User authentication tokens
- ✗ Personal information (email, phone numbers, etc.)
- ✗ Location data
- ✗ Browsing history
- ✗ Analytics or tracking data
- ✗ Data for advertising purposes

## 3. How We Use Information

### 3.1 Primary Purposes

Information is used **only** for:

1. **Message Link Expansion**: Generating embedded previews of Discord message links
2. **GitHub Permalink Expansion**: Retrieving and displaying code snippets from GitHub
3. **Performance Optimization**: Caching channel information to reduce API calls

### 3.2 What We Do NOT Do

- ✗ Sell or share data with third parties
- ✗ Use data for advertising or marketing
- ✗ Profile or track users
- ✗ Use data for purposes other than providing the Bot's core functionality

## 4. Data Storage and Security

### 4.1 Storage Location

- **Cache Storage**: In-memory only (no persistent database)
- **Server Location**: Depends on where the Bot is hosted
  - Official instance: Japan (if applicable)
  - Self-hosting: Your infrastructure

### 4.2 Data Retention Period

| Data Type | Retention Period |
|-----------|------------------|
| Message content | Real-time processing only (not stored) |
| Channel cache | Up to 12 hours (automatic cleanup) |
| Logs | Application logs may contain minimal metadata for debugging |

### 4.3 Security Measures

- All communication with Discord API uses HTTPS/TLS encryption
- No external database or persistent storage
- Automatic cache cleanup and expiration
- Open-source codebase for transparency and auditing

### 4.4 Data Breach Notification

In the unlikely event of a security incident:

- We will assess the scope and impact
- Affected users will be notified via Discord or GitHub
- Appropriate remedial actions will be taken immediately

## 5. Third-Party Services

The Bot integrates with the following third-party services:

### 5.1 Discord API
- **Purpose**: Core Bot functionality (sending/receiving messages)
- **Data Shared**: Message content, user IDs, channel IDs (as required by Discord API)
- **Privacy Policy**: [https://discord.com/privacy](https://discord.com/privacy)

### 5.2 GitHub API (Optional)
- **Purpose**: Retrieving raw file content for permalink expansion
- **When Enabled**: Only when GitHub permalink expansion is enabled in settings
- **Data Shared**: Repository URL, commit SHA, file path
- **Privacy Policy**: [https://docs.github.com/en/site-policy/privacy-policies/github-general-privacy-statement](https://docs.github.com/en/site-policy/privacy-policies/github-general-privacy-statement)

**Note**: We do not access user authentication or personal GitHub data.

## 6. Children's Privacy

The Bot does not knowingly collect information from users under 13 years of age (or the minimum age required in your jurisdiction). Discord's Terms of Service require users to be at least 13 years old.

## 7. Your Rights and Control

### 7.1 Access and Control

As a Discord user, you have the right to:

- **Remove the Bot**: You can remove the Bot from your server at any time
- **Restrict Access**: Control which channels the Bot can access through Discord permissions
- **Request Information**: Contact us to inquire about data processing

### 7.2 Guild Administrators

Server administrators can:

- Control the Bot's permissions on a per-channel basis
- Remove the Bot entirely from their server
- Disable specific features through configuration (e.g., GitHub permalink expansion)

### 7.3 Data Deletion

When you remove the Bot from your server:

- All cached data will expire within 12 hours
- No persistent data will remain (as none is permanently stored)

**Important Note**: Since the Bot uses only temporary in-memory caching, we cannot fulfill individual data deletion requests. Cache data automatically expires, and removing the Bot from your server will stop processing of new data related to that server.

## 8. International Data Transfers

If you use the Bot from outside Japan (where the official instance may be hosted):

- Data is processed in real-time and not permanently stored
- Cached data resides in the hosting region
- No cross-border transfer of personal data occurs for storage purposes

## 9. Changes to This Privacy Policy

This Privacy Policy may be updated from time to time. Changes will be posted at:

- **GitHub Repository**: [https://github.com/m1sk9/babyrite](https://github.com/m1sk9/babyrite)
- **Last Updated Date**: At the top of this document

Continued use of the Bot after changes constitutes acceptance of the updated Privacy Policy.

## 10. Legal Basis for Processing (GDPR)

For users in the European Economic Area (EEA):

- **Legitimate Interest**: Processing is necessary for the Bot's core functionality
- **Consent**: By inviting the Bot, you consent to the data processing described in this policy
- **Contractual Necessity**: Processing is necessary to provide the service you requested

### Your Rights Under GDPR

EEA users have additional rights under the GDPR:

- Right to access personal data
- Right to rectification
- Right to erasure ("right to be forgotten")※
- Right to restrict processing
- Right to data portability
- Right to object to processing

※ **Note**: Since the Bot uses only temporary in-memory caching and does not maintain a persistent database, we cannot fulfill individual data deletion requests. All cached data automatically expires.

To exercise these rights, contact us at me@m1sk9.dev.

## 11. California Privacy Rights (CCPA)

For California residents:

- **No Sale of Data**: We do not sell personal information
- **No Sharing for Advertising**: We do not share data for cross-context behavioral advertising
- **Right to Know**: You can request information about data collected
- **Right to Delete**: You can request deletion of your data※

※ **Note**: Since the Bot uses only temporary in-memory caching, all data automatically expires. We cannot fulfill individual data deletion requests, but the data we store is minimal and never permanently retained.

## 12. Contact Information

For privacy-related questions or concerns:

- **Email**: me@m1sk9.dev
- **Response Time**: We aim to respond within 7 business days

## 13. Transparency and Open Source

babyrite is committed to transparency:

- **Open Source**: Full source code is available at [https://github.com/m1sk9/babyrite](https://github.com/m1sk9/babyrite)
- **Auditable**: Anyone can review the code to verify data processing practices
- **Community-Driven**: Security and privacy concerns can be reported via GitHub Issues

## 14. Acknowledgment

By using the Bot, you acknowledge that:

- You have read and understood this Privacy Policy
- You consent to the data processing practices described herein
- You understand your rights and how to exercise them

---

**babyrite is not affiliated with Discord Inc. or GitHub Inc.**

**This Privacy Policy is effective as of the "Last Updated" date and applies to all users of the Bot.**
