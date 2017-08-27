--太古龙·对极龙
function c10162005.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--fusion material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_FUSION_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c10162005.fscon)
	e2:SetOperation(c10162005.fsop)
	c:RegisterEffect(e2)
	--special summon rule
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(c10162005.sprcon)
	e3:SetOperation(c10162005.sprop)
	c:RegisterEffect(e3)
	--Attribute Dark
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_ADD_ATTRIBUTE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e4)
	--immue
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10162005,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c10162005.imcost)
	e5:SetOperation(c10162005.imop)
	e5:SetCountLimit(1,10162005)
	c:RegisterEffect(e5) 
	--cannot attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(c10162005.antarget)
	c:RegisterEffect(e6) 
end

function c10162005.antarget(e,c)
	return c~=e:GetHandler()
end

function c10162005.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end

function c10162005.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		e1:SetValue(c10162005.efilter)
		c:RegisterEffect(e1)
end

function c10162005.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

function c10162005.spfilter1(c,tp)
	return c:IsSetCard(0x9333) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial()
		and Duel.IsExistingMatchingCard(c10162005.spfilter2,tp,LOCATION_MZONE,0,1,c,c:GetAttribute())
end
function c10162005.spfilter2(c,att)
	return c:IsSetCard(0x9333) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial() and c:GetAttribute()~=att 
end
function c10162005.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c10162005.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c10162005.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,c10162005.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,c10162005.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),g1:GetFirst():GetAttribute())
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,2,REASON_COST)
end

function c10162005.fscon(e,g,gc,chkf)
	if g==nil then return true end
	if gc then
		local mg=g:Filter(Card.IsSetCard,nil,0x9333)
		mg:AddCard(gc)
		return gc:IsSetCard(0x9333) and mg:GetClassCount(Card.GetAttribute)>=3
	end
	local fs=false
	local mg=g:Filter(Card.IsSetCard,nil,0x9333)
	if mg:IsExists(aux.FConditionCheckF,1,nil,chkf) then fs=true end
	return mg:GetClassCount(Card.GetAttribute)>=2 and (fs or chkf==PLAYER_NONE)
end

function c10162005.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	if gc then
		local sg=eg:Filter(Card.IsSetCard,gc,0x9333)
		sg:Remove(Card.IsAttribute,nil,gc:GetAttribute())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg:Select(tp,1,1,nil)
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=eg:Filter(Card.IsSetCard,nil,0x9333)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg:Select(tp,1,1,nil) end
	sg:Remove(Card.IsAttribute,nil,g1:GetFirst():GetAttribute())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:Select(tp,1,1,nil)
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end