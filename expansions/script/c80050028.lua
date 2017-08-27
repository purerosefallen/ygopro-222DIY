--新的正义！伊芙
function c80050028.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c80050028.splimit)
	c:RegisterEffect(e2)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c80050028.spcon)
	e0:SetOperation(c80050028.spop)
	c:RegisterEffect(e0)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3) 
	--material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80050028,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c80050028.mtop)
	c:RegisterEffect(e4)   
	--summon,flip
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetOperation(c80050028.handes)
	c:RegisterEffect(e5)
	--Untargetable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetRange(LOCATION_PZONE)
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(c80050028.immtg)
	e6:SetValue(aux.tgoval)
	c:RegisterEffect(e6)
	--Indes
	local e7=e6:Clone()
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetValue(c80050028.tgvalue)
	c:RegisterEffect(e7)
	--pendulum
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(80050028,2))
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_DESTROYED)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCondition(c80050028.pencon)
	e8:SetTarget(c80050028.pentg)
	e8:SetOperation(c80050028.penop)
	c:RegisterEffect(e8)
end
c80050028[0]=0
c80050028.pendulum_level=8
function c80050028.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c80050028.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x32d4) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM 
end
function c80050028.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x32d4) and c:IsAbleToRemoveAsCost() and c:IsLevelAbove(7)
end
function c80050028.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c80050028.filter,c:GetControler(),LOCATION_MZONE,0,2,nil)
end
function c80050028.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c80050028.filter,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c80050028.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroup(nil,1-tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,e:GetHandler())
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_XMATERIAL)
		local sg1=g1:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg1)
		Duel.Overlay(c,sg1)
	end
	if g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		Duel.Overlay(c,sg2)
	end
end
function c80050028.handes(e,tp,eg,ep,ev,re,r,rp)
	local loc,id=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_CHAIN_ID)
	if ep==tp or id==c80050028[0] or not re:IsActiveType(TYPE_MONSTER) then return end
	c80050028[0]=id
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(80050028,0)) then
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToRemove,1-tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Duel.BreakEffect()
	else Duel.NegateEffect(ev) 
	end
end
function c80050028.immtg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x32d4)
end
function c80050028.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c80050028.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c80050028.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end