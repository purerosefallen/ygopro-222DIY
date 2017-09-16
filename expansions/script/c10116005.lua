--夜鸦强盾
function c10116005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10116005,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10116005.target)
	e1:SetOperation(c10116005.activate)
	c:RegisterEffect(e1)  
	--NegateAttack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10116005,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10116005)
	e2:SetCondition(c10116005.necon)
	e2:SetCost(c10116005.necost)
	e2:SetTarget(c10116005.netg)
	e2:SetOperation(c10116005.neop)
	c:RegisterEffect(e2)
end
function c10116005.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10116005.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10116005.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c10116005.necon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c10116005.necost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c10116005.neop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.NegateAttack() and not Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(10116005,2)) then
	   Duel.BreakEffect()
	   Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	end
end
function c10116005.spfilter(c,e,tp)
	return c:IsSetCard(0x3331)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10116005.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3331)
end
function c10116005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	c10116005.announce_filter={0x3331,OPCODE_ISSETCARD}
	local ac=Duel.AnnounceCardFilter(tp,table.unpack(c10116005.announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
end
function c10116005.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac,c,ph=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM),e:GetHandler(),Duel.GetCurrentPhase()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3331))
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c10116005.efilter)
	e1:SetLabel(ac)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(c10116005.chainfilter)
	e2:SetLabel(ac)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetValue(c10116005.chainfilter)
	Duel.RegisterEffect(e3,tp)
end
function c10116005.chainfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:GetHandler():IsCode(e:GetLabel())
end
function c10116005.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end