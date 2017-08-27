--★フィギュア魔法少女　イフリナ
function c114000268.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(114000268,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c114000268.ntcon)
	e1:SetOperation(c114000268.ntop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--copy name and level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c114000268.condition)
	e2:SetCost(c114000268.cost)
	e2:SetOperation(c114000268.operation)
	c:RegisterEffect(e2)
end

function c114000268.ntcon(e,c)
	if c==nil then return true end
	return c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c114000268.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	--change base attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(1500)
	c:RegisterEffect(e1)
end

function c114000268.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_NORMAL+1
end
function c114000268.filter(c)	
	return c:IsType(TYPE_MONSTER) and ( c:IsSetCard(0x221) or c:IsCode(114000231) ) and c:IsAbleToGraveAsCost()
end
function c114000268.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114000268.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,c114000268.filter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(cg,REASON_COST)
	Duel.SetTargetCard(cg:GetFirst())
end
function c114000268.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or not tc:IsRelateToEffect(e) then return end
		local lv=tc:GetLevel()
		local e1=Effect.CreateEffect(c)
		local code=tc:GetCode()
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_CHANGE_LEVEL)		
		e2:SetValue(lv)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
end