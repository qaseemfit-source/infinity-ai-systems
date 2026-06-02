# Infinity AI Systems — Command Center

> AI-powered business operating system for Qaseem AI Agency. Manage clients, pipeline, lead prospecting, AI revenue audits, and automations — all in one dashboard.

## Live App
[https://infinity-ai-v8.pplx.app](https://infinity-ai-v8.pplx.app)

## Features
- **Dashboard** — Live MRR, client health, AI smart recommendations
- **My Clients** — Full client roster with health scores and MRR tracking
- **Pipeline** — Kanban-style deal tracking
- **Lead Prospector** — City-wide scan across 8 business categories using Google Places API (New). Finds businesses with no website = your warmest prospects.
- **AI Revenue Audit** — Automated gap analysis for client businesses
- **ROI Calculator** — Close rate and revenue projection tool
- **Sales Scripts** — Personalized cold call scripts per business type
- **Proposals** — AI-generated proposal builder
- **Voice Agents** — ElevenLabs integration hub
- **Workflows** — Make.com / n8n automation tracker
- **Unified Inbox** — Multi-channel communication hub

## Tech Stack
| Layer | Technology |
|-------|-----------|
| Frontend | React 18 (CDN, no build step) |
| Styling | Tailwind CSS v3 (CDN) |
| Icons | Lucide React |
| Lead Search | Google Places API (New) — REST |
| Voice | ElevenLabs |
| Automation | Make.com + n8n |
| SMS/Calls | Twilio |
| Database (V1) | Supabase |
| Hosting | pplx.app (Perplexity Computer) |

## Run Locally
Just open `index.html` in any modern browser — no build step, no dependencies to install.

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/infinity-ai-systems.git
cd infinity-ai-systems

# Open in browser
open index.html          # macOS
start index.html         # Windows
xdg-open index.html      # Linux
```

## Google Places API Setup
The Lead Prospector uses the **Places API (New)** REST endpoint.

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create a project → Enable **Places API (New)**
3. Create an API key → Restrict to your domain
4. Replace the key in `index.html`:
   ```
   var PLACES_KEY = 'YOUR_KEY_HERE';
   ```

Current key is restricted to the pplx.app domain. For local development, create a separate unrestricted key or add `localhost` to the allowed referrers.

## Supabase V1 Schema
See `/supabase/schema.sql` for the full database schema.

Tables: `clients`, `leads`, `pipeline_deals`, `user_settings`

## Project Structure
```
infinity-ai-systems/
├── index.html          # Complete single-file app (React + Tailwind inline)
├── supabase/
│   └── schema.sql      # V1 database schema
└── README.md
```

## Author
**Qaseem Abdul Sattar** — Army Veteran, CS Student, AI Consultant  
[Qaseem AI](https://infinity-ai-v8.pplx.app) | Woodbridge, VA

---
*Built with Perplexity Computer — AI Strategic Command Center*
