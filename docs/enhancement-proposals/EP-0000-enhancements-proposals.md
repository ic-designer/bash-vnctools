# EP-0000: Enhancement Proposals

    Name: Jeffrey Alan Fredenburg
    Date: 2024-04-13
    Status: Proposed

## Summary

A mechanism for tracking improvements is needed. The current mechanism of adding notes
to the `TODO.md` file is not adequate for proposing new new features. While the
`TODO.md` file will likely remain the primary mechanism for capturing ideas and bugs,
formal enhancement proposals are needed.

## Proposal

Introduce the following directory structure into the repo:
```
    docs/
        enhancement-proposals/
            EP-0000-enhancement-proposals.md
            ...
```

This directory will contain all the enhancement proposals. The enhancements proposals
shall conform to the following:

1.  Each proposal shall be named as `EP-<number>-<description>.md` where
    - `<number>` provides a unique identification number for each proposal starting at
      `0000` and incrementing consecutively for each addition proposal.
    - `<description>` provides a short description of the proposal consisting of only
      lowercase alphanumeric characters and hyphens.
2.  Each proposal shall include the following header specifying the author of the
      enhancement proposal, the date of the proposal, and the current status.
```
# EP-<number>: Title

    name: <name>
    date: <date>
    Status: <status>
```
3.  Each proposal shall include one of the following statuses:
    - `Proposed` - The proposal has been submitted for consideration.
    - `Accepted` - The proposal has been accepted and added.
    - `Rejected` - The proposal has been rejected and will not be added.
4.  Each proposal shall include the following sections:
    - `Summary` - Short description of what is needed and why.
    - `Proposal`- Full detailed description of the changes/additions.
