--Sentrification
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={13039848,57354389}
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,13039848)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,0,nil,13039848)
	for tc in aux.Next(g) do
		tc:Recreate(57354389,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
	end
	Duel.ConfirmCards(tp,g,true)
end
