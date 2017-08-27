--巨龙之坟场
function c10161001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--selfdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c10161001.con1)
	c:RegisterEffect(e2) 
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c10161001.disable)
	e3:SetCondition(c10161001.con2)
	e3:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e3)  
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetCondition(c10161001.con3)
	e4:SetValue(c10161001.efilter)
	c:RegisterEffect(e4) 
	--avoid damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CHANGE_DAMAGE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetValue(0)
	e5:SetCondition(c10161001.con4)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e6)
	--draw
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(10161001,0))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCondition(c10161001.con5)
	e7:SetTarget(c10161001.drtg)
	e7:SetOperation(c10161001.drop)
	c:RegisterEffect(e7)
	--recover
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetRange(LOCATION_FZONE)
	e8:SetCountLimit(1)
	e8:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e8:SetOperation(c10161001.reop)
	c:RegisterEffect(e8)
end
c10161001.card_code_list={10160001}
function c10161001.con1(e)
	return Duel.GetLP(e:GetHandlerPlayer())>=6000
end
function c10161001.con2(e)
	return Duel.GetLP(e:GetHandlerPlayer())>=4000
end
function c10161001.disable(e,c)
	return c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT
end
function c10161001.con3(e)
	return Duel.GetLP(e:GetHandlerPlayer())<=2000
end
function c10161001.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c10161001.con4(e)
	return Duel.GetLP(e:GetHandlerPlayer())<=1000
end
function c10161001.con5(e)
	return Duel.GetLP(e:GetHandlerPlayer())<=100
end
function c10161001.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10161001.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c10161001.filter(c)
	return c:IsSetCard(0x9333) and c:IsFaceup()
end
function c10161001.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10161001)
	Duel.Recover(tp,2000,REASON_EFFECT)
	if not Duel.IsExistingMatchingCard(c10161001.filter,tp,LOCATION_MZONE,0,1,nil) then
	   Duel.Recover(1-tp,2000,REASON_EFFECT)
	end
end