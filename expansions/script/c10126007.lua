--反骨王 勇
function c10126007.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),2,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)   
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c10126007.sprcon)
	e2:SetOperation(c10126007.sprop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c10126007.target)
	e3:SetValue(c10126007.indct)
	c:RegisterEffect(e3) 
	--indes(ai sound)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c10126007.reptg)
	e5:SetValue(c10126007.repval)
	--c:RegisterEffect(e5)
	--local g=Group.CreateGroup()
	--g:KeepAlive()
	--e5:SetLabelObject(g)  
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10126007,0))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c10126007.setg)
	e4:SetOperation(c10126007.seop)
	c:RegisterEffect(e4)
end
function c10126007.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10126007.sefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10126007.sefilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c10126007.seop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10126007.sefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10126007.target(e,c)
	local ec=c:GetEquipTarget()
	return ec and ec:IsControler(e:GetHandlerPlayer())
end
function c10126007.indct(e,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c10126007.repfilter(c,tp)
	local ec=c:GetEquipTarget()
	return ec and ec:IsControler(e:GetHandlerPlayer()) and c:GetFlagEffect(10140007)==0 
end

function c10126007.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10126007.repfilter,1,e:GetHandler(),tp) end
	local g=eg:Filter(c10126007.repfilter,e:GetHandler(),tp)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(10126007,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10126007,1))
		tc=g:GetNext()
	end
	e:GetLabelObject():Clear()
	e:GetLabelObject():Merge(g)
	return true
end

function c10126007.repval(e,c,re,tp)
	local g=e:GetLabelObject()
	return g:IsContains(c) and tp~=e:GetHandlerPlayer()
end
function c10126007.spfilter1(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial()
end
function c10126007.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c10126007.spfilter1,tp,LOCATION_MZONE,0,2,nil)
end
function c10126007.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10126007.spfilter1,tp,LOCATION_MZONE,0,2,2,nil)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_COST)
end