# Killing Machines - Dotfiles and Scripts

- All scripts ended with `.ts` are ment to be run with Deno

## New Killing Machine? \\(OwO)/

Set up your fresh new machine by running one of these commands:

```bash
curl -fsSL https://juanm04.com/nkm.sh | bash
wget -O - https://juanm04.com/nkm.sh | bash
```

## My Layout

My layout consists of the `us(altgr-intl)` layout with these modifications:

| Keys            | Final Character |
| :-------------- | :-------------: |
| `AltGr+9`       |        ª        |
| `AltGr+0`       |        º        |
| `AltGr+-`       |        —        |
| `AltGr+Shift+-` |        °        |
| `AltGr+=`       |        ±        |
| `AltGr+Shift+=` |        ×        |
| `AltGr+Shift+,` |        ≤        |
| `AltGr+.`       |        …        |
| `AltGr+Shift+.` |        ≥        |

As Adriaan says in a comment inside the US layout code:
> I do NOT like dead-keys - the International keyboard as defined by Microsoft
> does not fit my needs. Why use two keystrokes for all simple characters (eg '
> and <space> generates a single ') just to have an é (eacute) in two strokes
> as well? I type ' more often than é (eacute).
> 
> This file works just like a regular keyboard, BUT has all dead-keys
> accessible at level3 (through AltGr). An ë (ediaeresis) is now: AltGr+"
> followed by an e. In other words, this keyboard is not international as long
> as you leave the right Alt key alone.
> 
> The original MS International keyboard was intended for Latin1 (iso8859-1).
> With the introduction of iso8859-15, the (important) ligature oe (and OE)
> became available. I added them next to ae. Because I write ediaeresis more
> often than registered, I moved registered to be next to copyright and added
> ediaeresis and idiaeresis. - Adriaan

## TOP SNEAKY

Manage your secrets with `secrets-manager.sh`. When using `secrets-manager unzip`, make sure ro have a `sensitive.tar.enc` inside `.kmds/sensitive`.