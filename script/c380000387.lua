--Divine Artifacts
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={9161357}
s.listed_series={0x70}
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local token=Duel.CreateToken(tp,9161357)
	Duel.SendtoDeck(token,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
function s.cfilter(c,tp)
	return c:IsLevelAbove(1) and c:IsSetCard(0x70) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
		and Duel.IsExistingMatchingCard(s.lvfilter,tp,LOCATION_MZONE,0,1,nil,c:GetLevel())
end
function s.lvfilter(c,lv)
	return c:IsFaceup() and c:IsSetCard(0x70) and c:IsLevelAbove(1) and c:GetLevel()~=lv
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil,tp)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--reveal 1 Chronomaly monster in your hand
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	local lv=g:GetFirst():GetLevel()
	Duel.ShuffleHand(tp)
	--change the Level of all Chronomaly monsters on your field to the Level of the monster you revealed
	local sg=Duel.GetMatchingGroup(s.lvfilter,tp,LOCATION_MZONE,0,nil,lv)
	for tc in aux.Next(sg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
