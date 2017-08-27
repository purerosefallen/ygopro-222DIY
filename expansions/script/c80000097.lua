--口袋妖怪 波克比
function c80000097.initial_effect(c)
	--dice
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000097,0))
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,80000097+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c80000097.condition)
	e2:SetTarget(c80000097.target)
	e2:SetOperation(c80000097.operation)
	c:RegisterEffect(e2)
	--cannot be material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e3:SetValue(c80000097.splimit)
	c:RegisterEffect(e3)
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTarget(c80000097.syntg)
	e1:SetValue(1)
	e1:SetOperation(c80000097.synop)
	c:RegisterEffect(e1)
end
function c80000097.synfilter1(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c80000097.synfilter2(c,syncard,tuner,f)
	return c:IsSetCard(0x2d0) and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c80000097.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	if lv<=0 then return false end
	local g=Duel.GetMatchingGroup(c80000097.synfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	if syncard:IsSetCard(0x2d0) then
		local exg=Duel.GetMatchingGroup(c80000097.synfilter2,syncard:GetControler(),LOCATION_HAND,0,c,syncard,c,f)
		g:Merge(exg)
	end
	return g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
end
function c80000097.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local g=Duel.GetMatchingGroup(c80000097.synfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	if syncard:IsSetCard(0x2d0) then
		local exg=Duel.GetMatchingGroup(c80000097.synfilter2,syncard:GetControler(),LOCATION_HAND,0,c,syncard,c,f)
		g:Merge(exg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=g:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
	Duel.SetSynchroMaterial(sg)
end
function c80000097.splimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x2d0)
end
function c80000097.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c80000097.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c80000097.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local dice=Duel.TossDice(tp,1)
	if dice==1 then
		Duel.Draw(1-tp,1,REASON_EFFECT)
	elseif dice==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif dice==3 then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	elseif dice==4 then
		Duel.SetLP(tp,Duel.GetLP(tp)/2)
	elseif dice==5 then
		Duel.Recover(tp,2000,REASON_EFFECT)
	else
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end