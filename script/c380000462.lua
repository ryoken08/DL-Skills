--Phantom Regenerate
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_series={0xdb,0x2073}
function s.attfilter(c,atk)
	return c:IsSetCard(0xdb) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
s.filter=aux.FilterFaceupFunction(Card.IsSetCard,0x2073)
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.attfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Select 1 "Xyz Dragon" monster on your field
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if tc then
		--attach up to 2 "Phantom Knights" Spell/Trap Cards in your Graveyard
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=Duel.SelectMatchingCard(tp,s.attfilter,tp,LOCATION_GRAVE,0,1,2,nil)
		Duel.HintSelection(sg)
		if #sg>0 then
			Duel.Overlay(tc,sg)
		end
	end
end
