--Master of Fusion: Paladin
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
	-- Count special summons
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
s.listed_names={CARD_DARK_MAGICIAN,78193831,CARD_POLYMERIZATION,98502113}
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,id+1,RESET_PHASE+PHASE_END,0,1)
end
function s.filter(c)
	return not (c:IsMonster() and c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK))
end
function s.exfilter(c)
	return c:IsType(TYPE_FUSION) and not c:IsCode(98502113)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	return g:GetClassCount(Card.GetCode)==#g
		and not Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_EXTRA,0,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCountLimit(1)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)
	end
	e:SetLabel(1)
end
function s.tdfilter(c)
	return c:IsCode(CARD_DARK_MAGICIAN) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.IsCodeListed(c,CARD_DARK_MAGICIAN))
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--twice per duel check
	if Duel.GetFlagEffect(ep,id)>1 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_HAND,0,1,nil)
	and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	and Duel.GetFlagEffect(tp,id+1)<=1
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--flag register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--return 1 "Dark Magician" or a Spell/Trap that mentions "Dark Magician"
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
	--Add 1 "Buster Blader" from outside of your Deck to your hand
	local token=Duel.CreateToken(tp,78193831)
	Duel.SendtoHand(token,nil,REASON_RULE)
	Duel.ConfirmCards(1-tp,token)
	--Set 1 "Polymerization" to your Spell & Trap Zone
	local token1=Duel.CreateToken(tp,CARD_POLYMERIZATION)
	Duel.SSet(tp,token1)
	-- Cannot special summon more than once
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOwnerPlayer(tp)
	e1:SetCondition(s.spcon)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	--activates additional effect during your opponent's next turn
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetCountLimit(1)
	e2:SetOperation(s.operation)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	Duel.RegisterEffect(e2,tp)
	aux.RegisterClientHint(e:GetHandler(),nil,tp,1,0,aux.Stringid(id,1),RESET_OPPO_TURN)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
function s.spcon(e)
	return Duel.GetFlagEffect(e:GetOwnerPlayer(),id+1)>0
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	--cannot Special Summon any monsters
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
