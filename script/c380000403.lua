--Pendulum Extra Reset
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsType(TYPE_EXTRA)
end
function s.exfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_EXTRA)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and (Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil)
	or Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_EXTRA,0,1,nil))
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Return all face-up Pendulum Monsters in your Extra Deck to your Deck
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_EXTRA,0,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
	--Change all face-up Fusion, Synchro, and Xyz Pendulum Monsters in your Extra Deck face-down
	local sg=Duel.GetMatchingGroup(s.exfilter,tp,LOCATION_EXTRA,0,nil)
	if #sg>0 then
		for tc in aux.Next(sg) do
			local token=Duel.CreateToken(tp,tc:GetCode())
			Duel.SendtoDeck(tc,nil,-2,REASON_RULE)
			Duel.SendtoDeck(token,nil,SEQ_DECKTOP,REASON_RULE)
		end
	end
end
