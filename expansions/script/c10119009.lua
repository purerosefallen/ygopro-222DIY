--季风的使者 极光的欧若拉
function c10119009.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),4,2)
	c:EnableReviveLimit()  
	--chooseeffect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10119009,3))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_ATTACK)
	e1:SetCountLimit(2,10119009)
	e1:SetCost(c10119009.cost)
	e1:SetOperation(c10119009.operation)
	c:RegisterEffect(e1)	
end

function c10119009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10119009.atkcon(e)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	local bc=c:GetBattleTarget()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
		and c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE)
end
function c10119009.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c10119009.operation(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
   local op=Duel.SelectOption(tp,aux.Stringid(10119009,0),aux.Stringid(10119009,1),aux.Stringid(10119009,2))
   if op==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(c10119009.efilter)
		c:RegisterEffect(e1)
   elseif op==1 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetCondition(c10119009.atkcon)
		e2:SetValue(4000)
		c:RegisterEffect(e2) 
   else 
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_BATTLED)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e3:SetOperation(c10119009.atkop)
		c:RegisterEffect(e3)
   end
end
function c10119009.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=c:GetBattleTarget()
	if d and c:IsFaceup() and Card.IsCanBeXyzMaterial(d,c) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and d:IsStatus(STATUS_BATTLE_DESTROYED) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_SEND_REPLACE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetTarget(c10119009.reptg)
		e1:SetOperation(c10119009.repop)
		e1:SetLabelObject(c)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		d:RegisterEffect(e1)
	end
end
function c10119009.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_BATTLE) end
	return true
end
function c10119009.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
		 if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		  end
	Duel.Overlay(e:GetLabelObject(),Group.FromCards(c))
end
