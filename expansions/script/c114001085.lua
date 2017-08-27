--めざめのうた
function c114001085.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c114001085.condition)
	e1:SetTarget(c114001085.target)
	e1:SetOperation(c114001085.activate)
	c:RegisterEffect(e1)
end
function c114001085.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x221)
end
function c114001085.cfilter2(c)
	return c:IsFaceup() and not c:IsSetCard(0x221)
end
function c114001085.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c114001085.cfilter,tp,LOCATION_MZONE,0,1,nil) 
	and not Duel.IsExistingMatchingCard(c114001085.cfilter2,tp,LOCATION_MZONE,0,1,nil)
	and ( Duel.GetFieldCard(tp,LOCATION_SZONE,5)~=nil or Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)~=nil )
end
function c114001085.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),TYPE_SPELL+TYPE_TRAP)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c114001085.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),TYPE_SPELL+TYPE_TRAP)
	Duel.SendtoGrave(g,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end