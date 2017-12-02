--永远与须臾的罪人
function c1156016.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1156016.lcheck,3,4)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c1156016.splimit0)
	c:RegisterEffect(e0)  
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c1156016.tg1)
	e1:SetOperation(c1156016.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1156016,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCost(c1156016.cost2)
	e2:SetCondition(c1156016.con2)
	e2:SetTarget(c1156016.tg2)
	e2:SetOperation(c1156016.op2)
	c:RegisterEffect(e2)
--  
end
--
function c1156016.lcheck(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_EFFECT)
end
--
function c1156016.splimit0(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
--
function c1156016.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
--
function c1156016.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1156016)
	local c=e:GetHandler()
	if c:IsFaceup() then
		local res=Duel.TossCoin(tp,1)
		c1156016.arcanareg(c,res)
	end
end
function c1156016.arcanareg(c,coin)
--
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_UPDATE_ATTACK)
	e1_1:SetValue(1000)
	e1_1:SetCondition(c1156016.con1_1)
	e1_1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1_1)
--
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_SINGLE)
	e1_2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1_2:SetValue(1)
	e1_2:SetCondition(c1156016.con1_1)
	c:RegisterEffect(e1_2)
--
	local e1_3=Effect.CreateEffect(c)
	e1_3:SetType(EFFECT_TYPE_SINGLE)
	e1_3:SetCode(EFFECT_IMMUNE_EFFECT)
	e1_3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1_3:SetRange(LOCATION_MZONE)
	e1_3:SetCondition(c1156016.con1_1)
	e1_3:SetValue(c1156016.efilter1_3)
	c:RegisterEffect(e1_3)
--
	local e1_4=Effect.CreateEffect(c)
	e1_4:SetDescription(aux.Stringid(1156016,0))
	e1_4:SetCategory(CATEGORY_REMOVE)
	e1_4:SetType(EFFECT_TYPE_QUICK_O)
	e1_4:SetCode(EVENT_CHAINING)
	e1_4:SetRange(LOCATION_MZONE)
	e1_4:SetReset(RESET_EVENT+0x1fe0000)
	e1_4:SetCondition(c1156016.con1_4)
	e1_4:SetTarget(c1156016.tg1_4)
	e1_4:SetOperation(c1156016.op1_4)
	c:RegisterEffect(e1_4)
--
	c:RegisterFlagEffect(1156016,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
--
function c1156016.con1_1(e)
	return e:GetHandler():GetFlagEffectLabel(1156016)==1
end
function c1156016.efilter1_3(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
--
function c1156016.con1_4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffectLabel(1156016)==0 and rp~=tp and Duel.IsChainNegatable(ev) and bit.band(re:GetActivateLocation(),LOCATION_ONFIELD)==0
end
function c1156016.tg1_4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA+LOCATION_DECK)>0 end
end
function c1156016.op1_4(e,tp,eg,ep,ev,re,r,rp)
	local code=re:GetHandler():GetCode()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA+LOCATION_DECK)
	Duel.ConfirmCards(tp,g)
	local tg=g:Filter(Card.IsCode,nil,code)
	if tg:GetCount()>0 then
		Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
	end 
end
--
function c1156016.cfilter2_1(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function c1156016.cfilter2_2(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
end
function c1156016.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1156016.cfilter2_1,tp,LOCATION_ONFIELD,0,1,nil) or Duel.IsExistingMatchingCard(c1156016.cfilter2_2,tp,LOCATION_HAND,0,1,nil) end
	local g1=Duel.GetMatchingGroup(c1156016.cfilter2_1,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(c1156016.cfilter2_2,tp,LOCATION_HAND,0,nil)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=g1:Select(tp,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
--
function c1156016.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==e:GetHandler():GetControler() or 
	Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
--
function c1156016.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(1156016)~=0 and c:GetFlagEffect(1156015)==0 end
end
--
function c1156016.op2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(1156015,RESET_CHAIN,0,1)
	local c=e:GetHandler()
	if c:IsFaceup() and c:GetFlagEffect(1156016)~=0 then
		local val=c:GetFlagEffectLabel(1156016)
		c:SetFlagEffectLabel(1156016,1-val)
	end
end
--


