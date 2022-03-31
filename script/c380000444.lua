--Master of Rites: Super Soldier
local s,id=GetID()
function s.initial_effect(c)
	--skill
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
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
s.listed_names={45948430,5405694,73694478}
s.listed_series={0x10cf}
function s.IsSetCardListed(c,...)
	if not c.listed_series then return false end
	local setcodes={...}
	for _,setcode in ipairs(setcodes) do
		if type(c.listed_series)=='table' then
			for _,v in ipairs(c.listed_series) do
				if v==setcode then return true end
			end
		else
			if c.listed_series==setcode then return true end
		end
	end
	return false
end
function s.counterfilter(c)
	return c:IsSetCard(0x10cf)
end
function s.exfilter(c)
	return (c:IsRitualMonster() and c:IsSetCard(0x10cf)) or (c:IsMonster() and (aux.IsCodeListed(c,5405694) or s.IsSetCardListed(c,0x10cf)))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_DECK,0,6,nil)
	and Duel.GetMatchingGroup(s.exfilter,tp,LOCATION_DECK,0,nil):GetClassCount(Card.GetCode)>=4
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		--skill
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)
	end
	e:SetLabel(1)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0
	and Duel.IsExistingMatchingCard(Card.IsRitualMonster,tp,LOCATION_HAND,0,1,nil)
	and Duel.GetTurnCount()>=2
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Send 1 Ritual Monster from your hand to the Graveyard
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,Card.IsRitualMonster,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
		Duel.SendtoGrave(tc,REASON_RULE)
		if tc:IsLocation(LOCATION_REMOVED) then
			Duel.SendtoGrave(tc,REASON_RULE)
		end
	end
	--Add 1 "Super Soldier Synthesis" from outside of your Deck to your hand
	local token=Duel.CreateToken(tp,45948430)
	Duel.SendtoHand(token,nil,REASON_RULE)
	Duel.ConfirmCards(1-tp,token)
	--If you send "Black Luster Soldier" to the Graveyard, you can
	if tc:IsCode(5405694) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		--Place 1 face-down "Super Soldier Rebirth" from outside of your Deck to the field
		local token=Duel.CreateToken(tp,73694478)
		Duel.SSet(tp,token)
	end
	--You can only Special Summon "Black Luster Soldier" monsters
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
	--activate check
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetOperation(s.aclimit)
	Duel.RegisterEffect(e2,tp)
	--You can only activate 1 monster's effect during this Main Phase
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetTargetRange(1,0)
	e3:SetCondition(s.econ)
	e3:SetValue(s.elimit)
	if Duel.GetCurrentPhase()==PHASE_MAIN1 then
		e3:SetReset(RESET_PHASE+PHASE_MAIN1)
	else
		e3:SetReset(RESET_PHASE+PHASE_MAIN2)
	end
	Duel.RegisterEffect(e3,tp)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x10cf)
end
function s.aclimit(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsActiveType(TYPE_MONSTER) then return end
	Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
end
function s.econ(e)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),id+1)~=0
end
function s.elimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
