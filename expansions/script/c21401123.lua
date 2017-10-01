--Archer 吉尔伽美什
function c21401123.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xf02),1)
	c:EnableReviveLimit()
	c:EnableCounterPermit(0xf0f)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(c21401123.drcon)
	e1:SetTarget(c21401123.drtg)
	e1:SetOperation(c21401123.drop)
	c:RegisterEffect(e1)
	--boost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(600)
	c:RegisterEffect(e2)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EVENT_ADD_COUNTER+0xf0f)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c21401123.acop)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c21401123.remcost)
	e4:SetTarget(c21401123.remtg)
	e4:SetOperation(c21401123.remop)
	c:RegisterEffect(e4)
end
function c21401123.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c21401123.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c21401123.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c21401123.acop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xf0f,2)
end
function c21401123.filter(c)
	return c:IsFaceup() and c:IsAttackAbove(3000)
end
function c21401123.remcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xf0f,5,REASON_COST) end
	local c1=e:GetHandler():GetCounter(0xf0f)
	e:GetHandler():RemoveCounter(tp,0xf0f,5,REASON_COST)
	local c2=e:GetHandler():GetCounter(0xf0f)
	if c1==c2+5 then
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+0xf0f,e,0,tp,0,0)
	end
end
function c21401123.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21401123.filter,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function c21401123.remop(e,tp)
	local c=e:GetHandler()
	for i = 0,4 do
	    if Duel.CheckLocation(1-tp,LOCATION_MZONE,i) then
    	  local e1=Effect.CreateEffect(c)
	      e1:SetType(EFFECT_TYPE_FIELD)
	      e1:SetRange(LOCATION_MZONE)
		  e1:SetOperation(c21401123.disop)
		  e1:SetLabel(i+16)
	      e1:SetCode(EFFECT_DISABLE_FIELD)
	      c:RegisterEffect(e1)
        end
	end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)	
end
function c21401123.disop(e,tp)
	return bit.lshift(0x1,e:GetLabel())
end