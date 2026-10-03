#!/bin/bash
# Clone github.com/lucas-segundo/skills and install its lucas-skills plugin
SKILLS_DIR=/home/user/skills
if [ ! -d "$SKILLS_DIR/.git" ]; then
  git clone --depth 1 https://github.com/lucas-segundo/skills "$SKILLS_DIR" || echo "warn: skills clone failed"
else
  git -C "$SKILLS_DIR" pull --ff-only || echo "warn: skills pull failed"
fi
claude plugin marketplace add lucas-segundo/skills || echo "warn: marketplace add failed"
claude plugin install lucas-skills@lucas-plugins --scope user || echo "warn: plugin install failed"
exit 0
