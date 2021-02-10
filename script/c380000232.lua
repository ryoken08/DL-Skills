--Ultimate Dragons
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
s.listed_names={23995346,56532353,2129638,CARD_BLUEEYES_W_DRAGON,CARD_POLYMERIZATION}
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local token=Duel.CreateToken(tp,23995346)
	Duel.SendtoDeck(token,nil,SEQ_DECKTOP,REASON_RULE)
	local token2=Duel.CreateToken(tp,56532353)
	Duel.SendtoDeck(token2,nil,SEQ_DECKTOP,REASON_RULE)
	local token3=Duel.CreateToken(tp,2129638)
	Duel.SendtoDeck(token3,nil,SEQ_DECKTOP,REASON_RULE)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
function s.filter(c)
	return c:IsCode(CARD_BLUEEYES_W_DRAGON) and not c:IsPublic()
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.GetTurnCount()>=3
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,2,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,2,2,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
	end
	local token=Duel.CreateToken(tp,CARD_POLYMERIZATION)
	Duel.SendtoHand(token,nil,REASON_RULE)
	Duel.ConfirmCards(1-tp,token)
end
