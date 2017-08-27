--太古龙·巨岩龙
function c10162001.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x9333),9,2)
	c:EnableReviveLimit() 
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c10162001.atkcon)
	e1:SetValue(c10162001.atkval)
	c:RegisterEffect(e1)   
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10162001,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	--e2:SetCode(EVENT_FREE_CHAIN)
	--e2:SetHintTiming(0,0x1e0)
	e2:SetCountLimit(1,10162001)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c10162001.descost)
	e2:SetTarget(c10162001.destg)
	e2:SetOperation(c10162001.desop)
	c:RegisterEffect(e2) 
	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c10162001.antarget)
	c:RegisterEffect(e3)
end

function c10162001.antarget(e,c)
	return c~=e:GetHandler()
end

function c10162001.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10162001.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD)
end

function c10162001.filter(c)
	return c:IsDestructable() and c:IsAbleToRemove()
end

function c10162001.desop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,c10162001.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
		if dg and dg:GetCount()>0 then
		  Duel.HintSelection(dg)
		  Duel.Destroy(dg,REASON_EFFECT,LOCATION_REMOVED)
		end
end

function c10162001.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end

function c10162001.atkcon(e)
	return Duel.GetLP(e:GetHandlerPlayer())<4000
end

function c10162001.atkval(e,c)
	local lp=Duel.GetLP(c:GetControler())
	return 4000-lp
end