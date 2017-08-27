--红色世界
function c1150042.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
--   
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_BATTLE_DAMAGE_TO_EFFECT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.TRUE)
	c:RegisterEffect(e1)  
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(2,1150042)
	e2:SetCost(c1150042.cost2)
	e2:SetTarget(c1150042.tg2)
	e2:SetOperation(c1150042.op2)
	c:RegisterEffect(e2)  
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,1150043)
	e3:SetCondition(c1150042.con3)
	e3:SetOperation(c1150042.op3)
	c:RegisterEffect(e3) 
end
--
function c1150042.cfilter2(c)
	return c:IsCode(1150042) and c:IsAbleToRemoveAsCost()
end
function c1150042.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c1150042.cfilter2,tp,LOCATION_GRAVE, 0,nil)
	if chk==0 then return g:GetCount()>=3 end
	local rg=g:Select(tp,2,2,e:GetHandler())
	rg:AddCard(e:GetHandler())
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
--
function c1150042.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
--
function c1150042.op2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
	local e2_1=Effect.CreateEffect(e:GetHandler())
	e2_1:SetType(EFFECT_TYPE_FIELD)
	e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_AVAILABLE_BD)
	e2_1:SetTargetRange(0,1)
	e2_1:SetCode(EFFECT_CHANGE_DAMAGE)
	e2_1:SetValue(c1150042.val2_1)
	e2_1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2_1,tp)
end
function c1150042.val2_1(e,re,val,r,rp,rc)
	return val/2
end
--
function c1150042.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_DECK 
end
--
function c1150042.op3(e,tp,eg,ep,ev,re,r,rp)
	local e3_1=Effect.CreateEffect(e:GetHandler())
	e3_1:SetType(EFFECT_TYPE_FIELD)
	e3_1:SetCode(EFFECT_CHANGE_DAMAGE)
	e3_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3_1:SetTargetRange(1,1)
	e3_1:SetValue(c1150042.val3_1)
	Duel.RegisterEffect(e3_1,tp)
end
function c1150042.val3_1(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return val*3/2
	else return val end
end
--

