--I'm Always Near You
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
s.listed_names={78371393,4779091,31764700}
function s.filter(c)
	return c:IsYubel and c:IsFaceup()
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_REMOVED,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_REMOVED,0,nil)
	if #g>0 then
		--choose
		if Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))==0 then
			Duel.SendtoGrave(g,REASON_RULE+REASON_RETURN)
		else
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		end
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
