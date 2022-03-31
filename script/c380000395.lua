--Gateway to Another Dimension
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.AddSkillProcedure(c,1,false)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x70,0x48}
function s.filter(c)
	return c:IsMonster() and not c:IsSetCard(0x70)
end
function s.exfilter(c)
	return c:IsMonster() and not (c:IsSetCard(0x70) or (c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSetCard(0x48)))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return not Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil)
		and not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,12,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)
	end
	e:SetLabel(1)
end
function s.cfilter(c,tp)
	if c:IsType(TYPE_XYZ) then
		val=c:GetRank()
	else
		val=c:GetLevel()
	end
	return c:IsMonster()
		and Duel.IsExistingMatchingCard(s.lvfilter,tp,LOCATION_MZONE,0,1,nil,val)
end
function s.lvfilter(c,val)
	return c:IsFaceup() and c:IsMonster() and c:IsLevelAbove(1) and c:GetLevel()~=val
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,tp)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--send 1 monster from your Deck/Extra Deck to your Graveyard
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
	end
	Duel.SendtoGrave(tc,REASON_RULE)
	if tc:IsLocation(LOCATION_REMOVED) then
		Duel.SendtoGrave(tc,REASON_RULE)
	end
	if not tc:IsType(TYPE_EXTRA) and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND,0,1,nil,TYPE_MONSTER)
		and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,1,1,nil,TYPE_MONSTER)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_GRAVE)
		e2:SetReset(RESET_CHAIN)
		g1:GetFirst():RegisterEffect(e2)
		Duel.SendtoGrave(g1,REASON_RULE)
		if g1:GetFirst():IsLocation(LOCATION_REMOVED) then
			Duel.SendtoGrave(g1,REASON_RULE)
		end
	end
	local lv=nil
	if tc:IsType(TYPE_XYZ) then
		lv=tc:GetRank()
	else
		lv=tc:GetLevel()
	end
	--change the Level of all monsters on your field to the Level/Rank of the monster you sent to the GY
	local sg=Duel.GetMatchingGroup(s.lvfilter,tp,LOCATION_MZONE,0,nil,lv)
	if #sg==0 then return end
	for tc2 in aux.Next(sg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e1)
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
